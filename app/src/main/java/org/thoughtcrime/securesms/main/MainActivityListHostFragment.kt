package org.thoughtcrime.securesms.main

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.ActionMenuView
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.core.view.children
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.viewModels
import androidx.navigation.NavController
import androidx.navigation.NavDestination
import androidx.navigation.Navigator
import androidx.navigation.findNavController
import androidx.navigation.fragment.FragmentNavigatorExtras
import androidx.recyclerview.widget.RecyclerView
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.reactivex.rxjava3.annotations.NonNull
import io.reactivex.rxjava3.kotlin.subscribeBy
import org.signal.core.util.concurrent.LifecycleDisposable
import org.signal.core.util.concurrent.SimpleTask
import org.signal.core.util.logging.Log
import org.thoughtcrime.securesms.MainActivity
import org.thoughtcrime.securesms.R
import org.thoughtcrime.securesms.badges.BadgeImageView
import org.thoughtcrime.securesms.calls.log.CallLogFragment
import org.thoughtcrime.securesms.components.Material3SearchToolbar
import org.thoughtcrime.securesms.components.TooltipPopup
import org.thoughtcrime.securesms.components.settings.app.AppSettingsActivity
import org.thoughtcrime.securesms.components.settings.app.notifications.manual.NotificationProfileSelectionFragment
import org.thoughtcrime.securesms.conversationlist.ConversationListFragment
import org.thoughtcrime.securesms.keyvalue.SignalStore
import org.thoughtcrime.securesms.notifications.profiles.NotificationProfile
import org.thoughtcrime.securesms.notifications.profiles.NotificationProfiles
import org.thoughtcrime.securesms.recipients.Recipient
import org.thoughtcrime.securesms.stories.tabs.ConversationListTab
import org.thoughtcrime.securesms.stories.tabs.ConversationListTabsState
import org.thoughtcrime.securesms.stories.tabs.ConversationListTabsViewModel
import org.thoughtcrime.securesms.util.AvatarUtil
import org.thoughtcrime.securesms.util.BottomSheetUtil
import org.thoughtcrime.securesms.util.Material3OnScrollHelper
import org.thoughtcrime.securesms.util.TopToastPopup
import org.thoughtcrime.securesms.util.TopToastPopup.Companion.show
import org.thoughtcrime.securesms.util.Util
import org.thoughtcrime.securesms.util.runHideAnimation
import org.thoughtcrime.securesms.util.runRevealAnimation
import org.thoughtcrime.securesms.util.views.Stub
import org.thoughtcrime.securesms.util.visible
import org.whispersystems.signalservice.api.websocket.WebSocketConnectionState


class MainActivityListHostFragment : Fragment(R.layout.main_activity_list_host_fragment), ConversationListFragment.Callback,
  Material3OnScrollHelperBinder, CallLogFragment.Callback {

  companion object {
    private val TAG = Log.tag(MainActivityListHostFragment::class.java)
    private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"

  }

  private var flutterFragment: FlutterFragment? = null

  private val conversationListTabsViewModel: ConversationListTabsViewModel by viewModels(ownerProducer = { requireActivity() })
  private val disposables: LifecycleDisposable = LifecycleDisposable()

  private lateinit var _toolbarBackground: View
  private lateinit var _toolbar: Toolbar
  private lateinit var _basicToolbar: Stub<Toolbar>
  private lateinit var notificationProfileStatus: ImageView
  private lateinit var proxyStatus: ImageView
  private lateinit var _searchToolbar: Stub<Material3SearchToolbar>
  private lateinit var _searchAction: ImageView
  private lateinit var _unreadPaymentsDot: View

  private var previousTopToastPopup: TopToastPopup? = null

  private val destinationChangedListener = DestinationChangedListener()

  private val openSettings = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
    if (result.resultCode == MainActivity.RESULT_CONFIG_CHANGED) {
      requireActivity().recreate()
    }
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    disposables.bindTo(viewLifecycleOwner)

    _toolbarBackground = view.findViewById(R.id.toolbar_background)
    _toolbar = view.findViewById(R.id.toolbar)
    _basicToolbar = Stub(view.findViewById(R.id.toolbar_basic_stub))
    notificationProfileStatus = view.findViewById(R.id.conversation_list_notification_profile_status)
    proxyStatus = view.findViewById(R.id.conversation_list_proxy_status)
    _searchAction = view.findViewById(R.id.search_action)
    _searchToolbar = Stub(view.findViewById(R.id.search_toolbar))
    _unreadPaymentsDot = view.findViewById(R.id.unread_payments_indicator)

    notificationProfileStatus.setOnClickListener { handleNotificationProfile() }
    proxyStatus.setOnClickListener { onProxyStatusClicked() }

    initializeSettingsTouchTarget()

    (requireActivity() as AppCompatActivity).setSupportActionBar(_toolbar)


    // Get a reference to the Activity's FragmentManager to add a new FlutterFragment, or find an existing one.
    val fragmentManager: FragmentManager = parentFragmentManager

    // Attempt to find an existing FlutterFragment, in case this is not the first time that onCreate() was run.
    flutterFragment = fragmentManager.findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?

    val flutterEngine = FlutterEngine(requireContext())

    // Start executing Dart code in the FlutterEngine.
    flutterEngine.getDartExecutor().executeDartEntrypoint(
      DartExecutor.DartEntrypoint.createDefault()
    )

    // Cache the pre-warmed FlutterEngine to be used later by FlutterFragment.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine)


    disposables += conversationListTabsViewModel.state.subscribeBy { state ->
      val controller: NavController = requireView().findViewById<View>(R.id.fragment_container).findNavController()

      when (controller.currentDestination?.id) {

        R.id.conversationListFragment ->{
          if (flutterFragment != null) {
            flutterFragment!!.onStop()
          }
          goToStateFromConversationList(state, controller)
        }


        R.id.conversationListArchiveFragment -> Unit

        R.id.roomsFragment ->{
          goToStateFromRooms(state, controller)
        }


        R.id.callLogFragment ->{

          if (flutterFragment != null ) {
            flutterFragment!!.onStop()
          }
          goToStateFromCalling(state, controller)
        }
        R.id.discoverFragment ->{

          if (flutterFragment != null) {
            flutterFragment!!.onStop()
          }
          goToStateFromDiscover(state, controller)
        }
        R.id.appsFragment ->{
          if (flutterFragment != null) {
            flutterFragment!!.onStop()
          }
          goToStateFromApps(state, controller)
        }
      }

    }
  }

  override fun onBackPressed() {
    flutterFragment!!.onBackPressed()
  }

  override fun onNewIntent(@NonNull intent: Intent) {
    flutterFragment!!.onNewIntent(intent)
  }

  override fun onPostResume() {
    flutterFragment!!.onPostResume()
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<String?>,
    grantResults: IntArray
  ) {
    flutterFragment!!.onRequestPermissionsResult(
      requestCode,
      permissions,
      grantResults
    )
  }
  override fun onActivityResult(
    requestCode: Int,
    resultCode: Int,
    data: Intent?
  ) {
    super.onActivityResult(requestCode, resultCode, data)
    flutterFragment!!.onActivityResult(
      requestCode,
      resultCode,
      data
    )
  }

  override fun onUserLeaveHint() {
    flutterFragment!!.onUserLeaveHint()
  }

  override fun onTrimMemory(level: Int) {
    flutterFragment!!.onTrimMemory(level)
  }


  private fun goToStateFromConversationList(state: ConversationListTabsState, navController: NavController) {
    if (state.tab == ConversationListTab.CHATS) {
      return
    } else {
      val cameraFab = requireView().findViewById<View>(R.id.camera_fab)
      val newConvoFab = requireView().findViewById<View>(R.id.fab)

      ViewCompat.setTransitionName(cameraFab, "camera_fab")
      ViewCompat.setTransitionName(newConvoFab, "new_convo_fab")

      val extras: Navigator.Extras? = if (cameraFab == null || newConvoFab == null) {
        null
      } else {
        FragmentNavigatorExtras(
          cameraFab to "camera_fab",
          newConvoFab to "new_convo_fab"
        )
      }

      if (state.tab == ConversationListTab.ROOMS) {



        var newFlutterFragment = FlutterFragment.withCachedEngine("my_engine_id").build<FlutterFragment>()


//        var newFlutterFragment = FlutterFragment.createDefault()
        flutterFragment = newFlutterFragment
        fragmentManager
          ?.beginTransaction()
          ?.add(
            R.id.fragment_container,
            newFlutterFragment,
            TAG_FLUTTER_FRAGMENT
          )
          ?.commit()


      }
      else{
        val destination =if(state.tab == ConversationListTab.DISCOVER){
          R.id.action_conversationListFragment_to_discoverFragment
        }
        else if(state.tab == ConversationListTab.APPS){
          R.id.action_conversationListFragment_to_appsFragment
        }
        else {
          R.id.action_conversationListFragment_to_callLogFragment
        }
        navController.navigate(
          destination,
          null,
          null,
          extras
        )
      }


    }
  }

  private fun goToStateFromCalling(state: ConversationListTabsState, navController: NavController) {
    when (state.tab) {

      ConversationListTab.CALLS -> return
      ConversationListTab.CHATS -> navController.popBackStack(R.id.conversationListFragment, false)
      ConversationListTab.DISCOVER -> navController.navigate(R.id.action_callLogFragment_to_discoverFragment)
      ConversationListTab.APPS -> navController.navigate(R.id.action_callLogFragment_to_appsFragment)
      ConversationListTab.ROOMS -> {
        var newFlutterFragment = FlutterFragment.withCachedEngine("my_engine_id").build<FlutterFragment>()

//        var newFlutterFragment = FlutterFragment.createDefault()
        flutterFragment = newFlutterFragment
        fragmentManager
          ?.beginTransaction()
          ?.add(
            R.id.fragment_container,
            newFlutterFragment,
            TAG_FLUTTER_FRAGMENT
          )
          ?.commit()
      }
    }
  }

  private fun goToStateFromDiscover(state: ConversationListTabsState, navController: NavController) {

    when (state.tab) {
      ConversationListTab.DISCOVER -> return
      ConversationListTab.CHATS -> navController.popBackStack(R.id.conversationListFragment, false)
      ConversationListTab.CALLS -> navController.navigate(R.id.action_discoverFragment_to_callLogFragment)
      ConversationListTab.APPS -> navController.navigate(R.id.action_discoverFragment_to_appsFragment)
      ConversationListTab.ROOMS -> {
        var newFlutterFragment = FlutterFragment.createDefault()
        flutterFragment = newFlutterFragment
        fragmentManager
          ?.beginTransaction()
          ?.add(
            R.id.fragment_container,
            newFlutterFragment,
            TAG_FLUTTER_FRAGMENT
          )
          ?.commit()
      }

    }
  }
  private fun goToStateFromApps(state: ConversationListTabsState, navController: NavController) {


    when (state.tab) {

      ConversationListTab.APPS -> return
      ConversationListTab.CHATS -> navController.popBackStack(R.id.conversationListFragment, false)
      ConversationListTab.CALLS -> navController.navigate(R.id.action_appsFragment_to_callLogFragment)
      ConversationListTab.DISCOVER -> navController.navigate(R.id.action_appsFragment_to_discoverFragment)
      ConversationListTab.ROOMS -> {
        var newFlutterFragment = FlutterFragment.withCachedEngine("my_engine_id").build<FlutterFragment>()

//        var newFlutterFragment = FlutterFragment.createDefault()
        flutterFragment = newFlutterFragment
        fragmentManager
          ?.beginTransaction()
          ?.add(
            R.id.fragment_container,
            newFlutterFragment,
            TAG_FLUTTER_FRAGMENT
          )
          ?.commit()
      }


    }
  }


  private fun goToStateFromRooms(state: ConversationListTabsState, navController: NavController) {

    when (state.tab) {
      ConversationListTab.ROOMS -> return

      ConversationListTab.CHATS ->{

        navController.popBackStack(R.id.conversationListFragment, false)
      }

      ConversationListTab.CALLS ->{


        navController.navigate(R.id.action_roomsFragment_to_callLogFragment)

      }
      ConversationListTab.DISCOVER ->{

        navController.navigate(R.id.action_roomsFragment_to_discoverFragment)

      }
      ConversationListTab.APPS ->{

        navController.navigate(R.id.action_roomsFragment_to_appsFragment)

      }
    }
  }



  override fun onResume() {
    super.onResume()

    SimpleTask.run(viewLifecycleOwner.lifecycle, { Recipient.self() }, ::initializeProfileIcon)

    requireView()
      .findViewById<View>(R.id.fragment_container)
      .findNavController()
      .addOnDestinationChangedListener(destinationChangedListener)

  }

  override fun onPause() {
    super.onPause()
    requireView()
      .findViewById<View>(R.id.fragment_container)
      .findNavController()
      .removeOnDestinationChangedListener(destinationChangedListener)
  }

  private fun presentToolbarForConversationListFragment() {
    if (_basicToolbar.resolved() && _basicToolbar.get().visible) {
      _toolbar.runRevealAnimation(R.anim.slide_from_start)
    }

    _toolbar.visible = true
    _searchAction.visible = true

    if (_basicToolbar.resolved() && _basicToolbar.get().visible) {
      _basicToolbar.get().runHideAnimation(R.anim.slide_to_end)
    }
  }

  private fun presentToolbarForConversationListArchiveFragment() {
    _toolbar.runHideAnimation(R.anim.slide_to_start)
    _basicToolbar.get().runRevealAnimation(R.anim.slide_from_end)
  }

  private fun presentToolbarForStoriesLandingFragment() {
    _toolbar.visible = true
    _searchAction.visible = true
    if (_basicToolbar.resolved()) {
      _basicToolbar.get().visible = false
    }
  }

  private fun presentToolbarWithoutSearch() {
    _toolbar.visible = true
    _searchAction.visible = false
    if (_basicToolbar.resolved()) {
      _basicToolbar.get().visible = false
    }
  }



  private fun presentToolbarForCallLogFragment() {
    presentToolbarForConversationListFragment()
  }

  private fun presentToolbarForMultiselect() {
    _toolbar.visible = false
    if (_basicToolbar.resolved()) {
      _basicToolbar.get().visible = false
    }
  }







  override fun onDestroyView() {
    previousTopToastPopup = null
    super.onDestroyView()
  }

  override fun getToolbar(): Toolbar {
    return _toolbar
  }

  override fun getSearchAction(): ImageView {
    return _searchAction
  }

  override fun getSearchToolbar(): Stub<Material3SearchToolbar> {
    return _searchToolbar
  }

  override fun getUnreadPaymentsDot(): View {
    return _unreadPaymentsDot
  }

  override fun getBasicToolbar(): Stub<Toolbar> {
    return _basicToolbar
  }

  override fun onSearchOpened() {
    conversationListTabsViewModel.onSearchOpened()
    _searchToolbar.get().clearText()
    _searchToolbar.get().display(_searchAction.x + (_searchAction.width / 2.0f), _searchAction.y + (_searchAction.height / 2.0f))
  }

  override fun onSearchClosed() {
    conversationListTabsViewModel.onSearchClosed()
  }

  override fun onMultiSelectStarted() {
    presentToolbarForMultiselect()
    conversationListTabsViewModel.onMultiSelectStarted()
  }

  override fun onMultiSelectFinished() {
    val currentDestination: NavDestination? = requireView().findViewById<View>(R.id.fragment_container).findNavController().currentDestination
    if (currentDestination != null) {
      presentToolbarForDestination(currentDestination)
    }

    conversationListTabsViewModel.onMultiSelectFinished()
  }

  private fun initializeProfileIcon(recipient: Recipient) {
    Log.d(TAG, "Initializing profile icon")
    val icon = requireView().findViewById<ImageView>(R.id.toolbar_icon)
    val imageView: BadgeImageView = requireView().findViewById(R.id.toolbar_badge)
    imageView.setBadgeFromRecipient(recipient)
    AvatarUtil.loadIconIntoImageView(recipient, icon, resources.getDimensionPixelSize(R.dimen.toolbar_avatar_size))
  }

  private fun initializeSettingsTouchTarget() {
    val touchArea = requireView().findViewById<View>(R.id.toolbar_settings_touch_area)
    touchArea.setOnClickListener { openSettings.launch(AppSettingsActivity.home(requireContext())) }
  }

  private fun handleNotificationProfile() {
    NotificationProfileSelectionFragment.show(parentFragmentManager)
  }

  private fun onProxyStatusClicked() {
    startActivity(AppSettingsActivity.proxy(requireContext()))
  }

  override fun updateProxyStatus(state: WebSocketConnectionState) {
    if (SignalStore.proxy().isProxyEnabled) {
      proxyStatus.visibility = View.VISIBLE
      when (state) {
        WebSocketConnectionState.CONNECTING, WebSocketConnectionState.DISCONNECTING, WebSocketConnectionState.DISCONNECTED -> proxyStatus.setImageResource(R.drawable.ic_proxy_connecting_24)
        WebSocketConnectionState.CONNECTED -> proxyStatus.setImageResource(R.drawable.ic_proxy_connected_24)
        WebSocketConnectionState.AUTHENTICATION_FAILED, WebSocketConnectionState.FAILED -> proxyStatus.setImageResource(R.drawable.ic_proxy_failed_24)
        else -> proxyStatus.visibility = View.GONE
      }
    } else {
      proxyStatus.visibility = View.GONE
    }
  }

  override fun updateNotificationProfileStatus(notificationProfiles: List<NotificationProfile>) {
    val activeProfile = NotificationProfiles.getActiveProfile(notificationProfiles)
    if (activeProfile != null) {
      if (activeProfile.id != SignalStore.notificationProfileValues().lastProfilePopup) {
        requireView().postDelayed({
          SignalStore.notificationProfileValues().lastProfilePopup = activeProfile.id
          SignalStore.notificationProfileValues().lastProfilePopupTime = System.currentTimeMillis()
          if (previousTopToastPopup?.isShowing == true) {
            previousTopToastPopup?.dismiss()
          }
          var view = requireView() as ViewGroup
          val fragment = parentFragmentManager.findFragmentByTag(BottomSheetUtil.STANDARD_BOTTOM_SHEET_FRAGMENT_TAG)
          if (fragment != null && fragment.isAdded && fragment.view != null) {
            view = fragment.requireView() as ViewGroup
          }
          try {
            previousTopToastPopup = show(view, R.drawable.ic_moon_16, getString(R.string.ConversationListFragment__s_on, activeProfile.name))
          } catch (e: Exception) {
            Log.w(TAG, "Unable to show toast popup", e)
          }
        }, 500L)
      }
      notificationProfileStatus.visibility = View.VISIBLE
    } else {
      notificationProfileStatus.visibility = View.GONE
    }
    if (!SignalStore.notificationProfileValues().hasSeenTooltip && Util.hasItems(notificationProfiles)) {
      val target: View? = findOverflowMenuButton(_toolbar)
      if (target != null) {
        TooltipPopup.forTarget(target)
          .setText(R.string.ConversationListFragment__turn_your_notification_profile_on_or_off_here)
          .setBackgroundTint(ContextCompat.getColor(requireContext(), R.color.signal_button_primary))
          .setTextColor(ContextCompat.getColor(requireContext(), R.color.signal_button_primary_text))
          .setOnDismissListener { SignalStore.notificationProfileValues().hasSeenTooltip = true }
          .show(TooltipPopup.POSITION_BELOW)
      } else {
        Log.w(TAG, "Unable to find overflow menu to show Notification Profile tooltip")
      }
    }
  }

  private fun findOverflowMenuButton(viewGroup: Toolbar): View? {
    return viewGroup.children.find { it is ActionMenuView }
  }

  private fun presentToolbarForDestination(destination: NavDestination) {
    when (destination.id) {

      R.id.conversationListFragment -> {
        conversationListTabsViewModel.isShowingArchived(false)
        presentToolbarForConversationListFragment()
      }

      R.id.conversationListArchiveFragment -> {
        conversationListTabsViewModel.isShowingArchived(true)
        presentToolbarForConversationListArchiveFragment()
      }

      R.id.storiesLandingFragment -> {
        conversationListTabsViewModel.isShowingArchived(false)
        presentToolbarForStoriesLandingFragment()
      }

      R.id.callLogFragment -> {
        conversationListTabsViewModel.isShowingArchived(false)
        presentToolbarForCallLogFragment()
      }

      R.id.discoverFragment -> {
        conversationListTabsViewModel.isShowingArchived(false)
        presentToolbarWithoutSearch()
      }

      R.id.appsFragment -> {
        conversationListTabsViewModel.isShowingArchived(false)
        presentToolbarWithoutSearch()
      }

      R.id.roomsFragment -> {
        conversationListTabsViewModel.isShowingArchived(false)
        presentToolbarWithoutSearch()
      }
    }
  }

  private inner class DestinationChangedListener : NavController.OnDestinationChangedListener {
    override fun onDestinationChanged(controller: NavController, destination: NavDestination, arguments: Bundle?) {
      presentToolbarForDestination(destination)
    }
  }

  override fun bindScrollHelper(recyclerView: RecyclerView) {
    Material3OnScrollHelper(
      requireActivity(),
      listOf(_toolbarBackground),
      listOf(_searchToolbar),
      viewLifecycleOwner
    ).attach(recyclerView)
  }


}

