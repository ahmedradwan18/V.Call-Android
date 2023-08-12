package org.variiance.vcall.profiles.edit;

import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.util.Consumer;

import org.signal.core.util.StreamUtil;
import org.signal.core.util.logging.Log;
import org.variiance.vcall.conversation.colors.AvatarColor;
import org.variiance.vcall.database.SignalDatabase;
import org.variiance.vcall.dependencies.ApplicationDependencies;
import org.variiance.vcall.jobs.MultiDeviceProfileContentUpdateJob;
import org.variiance.vcall.jobs.MultiDeviceProfileKeyUpdateJob;
import org.variiance.vcall.jobs.ProfileUploadJob;
import org.variiance.vcall.keyvalue.SignalStore;
import org.variiance.vcall.profiles.AvatarHelper;
import org.variiance.vcall.profiles.ProfileMediaConstraints;
import org.variiance.vcall.profiles.ProfileName;
import org.variiance.vcall.profiles.SystemProfileUtil;
import org.variiance.vcall.recipients.Recipient;
import org.variiance.vcall.recipients.RecipientId;
import org.variiance.vcall.registration.RegistrationUtil;
import org.variiance.vcall.util.concurrent.ListenableFuture;
import org.signal.core.util.concurrent.SimpleTask;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.Optional;
import java.util.concurrent.ExecutionException;

public class EditSelfProfileRepository implements EditProfileRepository {

  private static final String TAG = Log.tag(EditSelfProfileRepository.class);

  private final Context context;
  private final boolean excludeSystem;

  EditSelfProfileRepository(@NonNull Context context, boolean excludeSystem) {
    this.context        = context.getApplicationContext();
    this.excludeSystem  = excludeSystem;
  }

  @Override
  public void getCurrentAvatarColor(@NonNull Consumer<AvatarColor> avatarColorConsumer) {
    SimpleTask.run(() -> Recipient.self().getAvatarColor(), avatarColorConsumer::accept);
  }

  @Override
  public void getCurrentProfileName(@NonNull Consumer<ProfileName> profileNameConsumer) {
    ProfileName storedProfileName = Recipient.self().getProfileName();
    if (!storedProfileName.isEmpty()) {
      profileNameConsumer.accept(storedProfileName);
    } else if (!excludeSystem) {
      SystemProfileUtil.getSystemProfileName(context).addListener(new ListenableFuture.Listener<String>() {
        @Override
        public void onSuccess(String result) {
          if (!TextUtils.isEmpty(result)) {
            profileNameConsumer.accept(ProfileName.fromSerialized(result));
          } else {
            profileNameConsumer.accept(storedProfileName);
          }
        }

        @Override
        public void onFailure(ExecutionException e) {
          Log.w(TAG, e);
          profileNameConsumer.accept(storedProfileName);
        }
      });
    } else {
      profileNameConsumer.accept(storedProfileName);
    }
  }

  @Override
  public void getCurrentAvatar(@NonNull Consumer<byte[]> avatarConsumer) {
    RecipientId selfId = Recipient.self().getId();

    if (AvatarHelper.hasAvatar(context, selfId)) {
      SimpleTask.run(() -> {
        try {
          return StreamUtil.readFully(AvatarHelper.getAvatar(context, selfId));
        } catch (IOException e) {
          Log.w(TAG, e);
          return null;
        }
      }, avatarConsumer::accept);
    } else if (!excludeSystem) {
      SystemProfileUtil.getSystemProfileAvatar(context, new ProfileMediaConstraints()).addListener(new ListenableFuture.Listener<byte[]>() {
        @Override
        public void onSuccess(byte[] result) {
          avatarConsumer.accept(result);
        }

        @Override
        public void onFailure(ExecutionException e) {
          Log.w(TAG, e);
          avatarConsumer.accept(null);
        }
      });
    }
  }

  @Override
  public void getCurrentDisplayName(@NonNull Consumer<String> displayNameConsumer) {
    displayNameConsumer.accept("");
  }

  @Override
  public void getCurrentName(@NonNull Consumer<String> nameConsumer) {
    nameConsumer.accept("");
  }

  @Override public void getCurrentDescription(@NonNull Consumer<String> descriptionConsumer) {
    descriptionConsumer.accept("");
  }

  @Override
  public void uploadProfile(@NonNull ProfileName profileName,
                            @NonNull String displayName,
                            boolean displayNameChanged,
                            @NonNull String description,
                            boolean descriptionChanged,
                            @Nullable byte[] avatar,
                            boolean avatarChanged,
                            @NonNull Consumer<UploadResult> uploadResultConsumer)
  {
    SimpleTask.run(() -> {
      SignalDatabase.recipients().setProfileName(Recipient.self().getId(), profileName);

      if (avatarChanged) {
        try {
          AvatarHelper.setAvatar(context, Recipient.self().getId(), avatar != null ? new ByteArrayInputStream(avatar) : null);
        } catch (IOException e) {
          return UploadResult.ERROR_IO;
        }
      }

      ApplicationDependencies.getJobManager()
                             .startChain(new ProfileUploadJob())
                             .then(Arrays.asList(new MultiDeviceProfileKeyUpdateJob(), new MultiDeviceProfileContentUpdateJob()))
                             .enqueue();

      RegistrationUtil.maybeMarkRegistrationComplete();

      if (avatar != null) {
        SignalStore.misc().markHasEverHadAnAvatar();
      }

      return UploadResult.SUCCESS;
    }, uploadResultConsumer::accept);
  }

  @Override
  public void getCurrentUsername(@NonNull Consumer<Optional<String>> callback) {
    callback.accept(Recipient.self().getUsername());
  }
}
