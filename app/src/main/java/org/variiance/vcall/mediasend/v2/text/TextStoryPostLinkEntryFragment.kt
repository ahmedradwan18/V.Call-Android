package org.variiance.vcall.mediasend.v2.text

import android.content.DialogInterface
import android.os.Bundle
import android.text.TextUtils
import android.view.View
import android.widget.EditText
import androidx.constraintlayout.widget.Group
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.viewModels
import com.google.android.material.snackbar.Snackbar
import org.variiance.vcall.R
import org.variiance.vcall.components.KeyboardEntryDialogFragment
import org.variiance.vcall.linkpreview.LinkPreviewRepository
import org.variiance.vcall.linkpreview.LinkPreviewViewModel
import org.variiance.vcall.stories.StoryLinkPreviewView
import org.variiance.vcall.util.LinkUtil
import org.variiance.vcall.util.TextSecurePreferences
import org.variiance.vcall.util.ViewUtil
import org.variiance.vcall.util.setIncognitoKeyboardEnabled
import org.variiance.vcall.util.visible

class TextStoryPostLinkEntryFragment : KeyboardEntryDialogFragment(
  contentLayoutId = R.layout.stories_text_post_link_entry_fragment
) {

  private lateinit var input: EditText

  private val linkPreviewViewModel: LinkPreviewViewModel by viewModels(
    factoryProducer = { LinkPreviewViewModel.Factory(LinkPreviewRepository(), true) }
  )

  private val viewModel: TextStoryPostCreationViewModel by viewModels(
    ownerProducer = {
      requireActivity()
    }
  )

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    input = view.findViewById(R.id.input)

    val linkPreview: StoryLinkPreviewView = view.findViewById(R.id.link_preview)
    val confirmButton: View = view.findViewById(R.id.confirm_button)
    val shareALinkGroup: Group = view.findViewById(R.id.share_a_link_group)

    input.setIncognitoKeyboardEnabled(TextSecurePreferences.isIncognitoKeyboardEnabled(requireContext()))
    input.addTextChangedListener(
      afterTextChanged = {
        val scheme = "https://"
        val (uriString, selectionStart, selectionEnd) = if (it!!.startsWith(scheme)) {
          Triple(it, input.selectionStart, input.selectionEnd)
        } else {
          Triple("$scheme$it", input.selectionStart + scheme.length, input.selectionEnd + scheme.length)
        }

        linkPreviewViewModel.onTextChanged(requireContext(), uriString.toString(), selectionStart, selectionEnd)
      }
    )

    confirmButton.isEnabled = false
    confirmButton.setOnClickListener {
      val linkPreviewState = linkPreviewViewModel.linkPreviewState.value
      if (linkPreviewState != null) {
        val url = linkPreviewState.linkPreview.map { it.url }.orElseGet { linkPreviewState.activeUrlForError }

        if (LinkUtil.isValidTextStoryPostPreview(url)) {
          viewModel.setLinkPreview(url)
          dismissAllowingStateLoss()
        } else {
          val snackbar = Snackbar.make(requireView(), R.string.TextStoryPostSendFragment__please_enter_a_valid_link, Snackbar.LENGTH_SHORT)
          snackbar.anchorView = linkPreview
          snackbar.show()
        }
      } else {
        dismissAllowingStateLoss()
      }
    }

    linkPreviewViewModel.linkPreviewState.observe(viewLifecycleOwner) { state ->
      linkPreview.bind(state, useLargeThumbnail = false)
      shareALinkGroup.visible = !state.isLoading && !state.linkPreview.isPresent && (state.error == null && state.activeUrlForError == null)
      confirmButton.isEnabled = state.linkPreview.isPresent || !TextUtils.isEmpty(state.activeUrlForError)
    }
  }

  override fun onResume() {
    super.onResume()
    ViewUtil.focusAndShowKeyboard(input)
  }

  override fun onDismiss(dialog: DialogInterface) {
    linkPreviewViewModel.onSend()
    super.onDismiss(dialog)
  }
}
