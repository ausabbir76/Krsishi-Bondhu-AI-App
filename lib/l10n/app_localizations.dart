import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KrishiBondhu AI'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get tabAssistant;

  /// No description provided for @tabTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tabTools;

  /// No description provided for @tabMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get tabMarket;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @heroChip.
  ///
  /// In en, this message translates to:
  /// **'🌾 Your AI Farming Companion'**
  String get heroChip;

  /// No description provided for @heroCountry.
  ///
  /// In en, this message translates to:
  /// **'KrishiBondhu AI'**
  String get heroCountry;

  /// No description provided for @heroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Bangla-Native\nAI Farming Assistant'**
  String get heroHeadline;

  /// No description provided for @heroDescription.
  ///
  /// In en, this message translates to:
  /// **'Voice conversations, crop disease detection, satellite imagery, soil intelligence and weather forecasting — built for Bangladesh, in Bangla.'**
  String get heroDescription;

  /// No description provided for @ctaScanCrop.
  ///
  /// In en, this message translates to:
  /// **'Scan a Crop'**
  String get ctaScanCrop;

  /// No description provided for @ctaWeatherToday.
  ///
  /// In en, this message translates to:
  /// **'Weather Today'**
  String get ctaWeatherToday;

  /// No description provided for @statDetectionAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Detection accuracy'**
  String get statDetectionAccuracy;

  /// No description provided for @statAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI assistant'**
  String get statAiAssistant;

  /// No description provided for @statSupportedCrops.
  ///
  /// In en, this message translates to:
  /// **'Supported crops'**
  String get statSupportedCrops;

  /// No description provided for @modulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Six AI systems, one companion'**
  String get modulesTitle;

  /// No description provided for @modulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every module is trained on Bangladesh\'s crops, weather and farming realities.'**
  String get modulesSubtitle;

  /// No description provided for @moduleVoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Voice Assistant'**
  String get moduleVoiceTitle;

  /// No description provided for @moduleVoiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Speak in Bangla — natural conversations with memory and personalized advice.'**
  String get moduleVoiceDesc;

  /// No description provided for @moduleDiseaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Disease Detection'**
  String get moduleDiseaseTitle;

  /// No description provided for @moduleDiseaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo. Get the disease, severity and treatment in seconds.'**
  String get moduleDiseaseDesc;

  /// No description provided for @moduleSatelliteTitle.
  ///
  /// In en, this message translates to:
  /// **'Satellite Intelligence'**
  String get moduleSatelliteTitle;

  /// No description provided for @moduleSatelliteDesc.
  ///
  /// In en, this message translates to:
  /// **'NDVI, water stress, flood mapping and yield estimates from Sentinel-2.'**
  String get moduleSatelliteDesc;

  /// No description provided for @moduleSoilTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Intelligence'**
  String get moduleSoilTitle;

  /// No description provided for @moduleSoilDesc.
  ///
  /// In en, this message translates to:
  /// **'GPS or soil report in — suitable crops, NPK, pH and fertilizer plan out.'**
  String get moduleSoilDesc;

  /// No description provided for @moduleWeatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather Intelligence'**
  String get moduleWeatherTitle;

  /// No description provided for @moduleWeatherDesc.
  ///
  /// In en, this message translates to:
  /// **'BMD, NASA and OpenWeather combined — explained in simple Bangla.'**
  String get moduleWeatherDesc;

  /// No description provided for @moduleMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get moduleMarketTitle;

  /// No description provided for @moduleMarketDesc.
  ///
  /// In en, this message translates to:
  /// **'Verified buyers, machinery rental and daily market prices.'**
  String get moduleMarketDesc;

  /// No description provided for @howTitle.
  ///
  /// In en, this message translates to:
  /// **'Three steps. Any farm.'**
  String get howTitle;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Speak or upload'**
  String get step1Title;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Ask a question in Bangla or upload a photo of your crop.'**
  String get step1Desc;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'AI understands'**
  String get step2Title;

  /// No description provided for @step2Desc.
  ///
  /// In en, this message translates to:
  /// **'Analyzes weather, soil, satellite and agricultural knowledge for your farm.'**
  String get step2Desc;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Get recommendations'**
  String get step3Title;

  /// No description provided for @step3Desc.
  ///
  /// In en, this message translates to:
  /// **'Personalized guidance in Bangla — organic or chemical, whatever works.'**
  String get step3Desc;

  /// No description provided for @cropsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supported crops'**
  String get cropsTitle;

  /// No description provided for @roadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s next'**
  String get roadmapTitle;

  /// No description provided for @roadmapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re expanding beyond the phone — into the sky, the soil and the marketplace.'**
  String get roadmapSubtitle;

  /// No description provided for @roadmapDrone.
  ///
  /// In en, this message translates to:
  /// **'Drone monitoring'**
  String get roadmapDrone;

  /// No description provided for @roadmapIot.
  ///
  /// In en, this message translates to:
  /// **'IoT soil sensors'**
  String get roadmapIot;

  /// No description provided for @roadmapIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Smart irrigation'**
  String get roadmapIrrigation;

  /// No description provided for @roadmapLivestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock assistant'**
  String get roadmapLivestock;

  /// No description provided for @roadmapPest.
  ///
  /// In en, this message translates to:
  /// **'Pest prediction'**
  String get roadmapPest;

  /// No description provided for @roadmapInsurance.
  ///
  /// In en, this message translates to:
  /// **'Crop insurance'**
  String get roadmapInsurance;

  /// No description provided for @cropRice.
  ///
  /// In en, this message translates to:
  /// **'🌾 Rice'**
  String get cropRice;

  /// No description provided for @cropMaize.
  ///
  /// In en, this message translates to:
  /// **'🌽 Maize'**
  String get cropMaize;

  /// No description provided for @cropPotato.
  ///
  /// In en, this message translates to:
  /// **'🥔 Potato'**
  String get cropPotato;

  /// No description provided for @cropTomato.
  ///
  /// In en, this message translates to:
  /// **'🍅 Tomato'**
  String get cropTomato;

  /// No description provided for @cropCabbage.
  ///
  /// In en, this message translates to:
  /// **'🥬 Cabbage'**
  String get cropCabbage;

  /// No description provided for @cropChili.
  ///
  /// In en, this message translates to:
  /// **'🌶️ Chili'**
  String get cropChili;

  /// No description provided for @cropOnion.
  ///
  /// In en, this message translates to:
  /// **'🧅 Onion'**
  String get cropOnion;

  /// No description provided for @cropCucumber.
  ///
  /// In en, this message translates to:
  /// **'🥒 Cucumber'**
  String get cropCucumber;

  /// No description provided for @cropEggplant.
  ///
  /// In en, this message translates to:
  /// **'🍆 Eggplant'**
  String get cropEggplant;

  /// No description provided for @cropLentil.
  ///
  /// In en, this message translates to:
  /// **'🫛 Lentil'**
  String get cropLentil;

  /// No description provided for @cropJute.
  ///
  /// In en, this message translates to:
  /// **'🌱 Jute'**
  String get cropJute;

  /// No description provided for @cropBanana.
  ///
  /// In en, this message translates to:
  /// **'🍌 Banana'**
  String get cropBanana;

  /// No description provided for @cropMango.
  ///
  /// In en, this message translates to:
  /// **'🥭 Mango'**
  String get cropMango;

  /// No description provided for @cropMustard.
  ///
  /// In en, this message translates to:
  /// **'🫘 Mustard'**
  String get cropMustard;

  /// No description provided for @cropWatermelon.
  ///
  /// In en, this message translates to:
  /// **'🍉 Watermelon'**
  String get cropWatermelon;

  /// No description provided for @assistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'বাংলায় প্রশ্ন করুন — ask anything about your farm'**
  String get assistantSubtitle;

  /// No description provided for @assistantEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'কৃষিবন্ধু এআই'**
  String get assistantEmptyTitle;

  /// No description provided for @assistantEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your farming questions, answered in Bangla.'**
  String get assistantEmptySubtitle;

  /// No description provided for @tryAsking.
  ///
  /// In en, this message translates to:
  /// **'TRY ASKING'**
  String get tryAsking;

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type a question… / প্রশ্ন লিখুন…'**
  String get chatPlaceholder;

  /// No description provided for @micComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Bangla voice input is coming soon 🎙️'**
  String get micComingSoon;

  /// No description provided for @chatError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, something went wrong: {error}'**
  String chatError(String error);

  /// No description provided for @chatHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatHistoryTitle;

  /// No description provided for @chatHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your past conversations with KrishiBondhu'**
  String get chatHistorySubtitle;

  /// No description provided for @chatNew.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get chatNew;

  /// No description provided for @chatDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete chat'**
  String get chatDelete;

  /// No description provided for @chatAllChats.
  ///
  /// In en, this message translates to:
  /// **'All chats'**
  String get chatAllChats;

  /// No description provided for @chatHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get chatHistoryEmpty;

  /// No description provided for @chatHistoryEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation to see it here.'**
  String get chatHistoryEmptySub;

  /// No description provided for @chatMessageCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 message} other{{count} messages}}'**
  String chatMessageCount(int count);

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Tools'**
  String get toolsTitle;

  /// No description provided for @toolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All KrishiBondhu intelligence modules in one place'**
  String get toolsSubtitle;

  /// No description provided for @sectionDiagnose.
  ///
  /// In en, this message translates to:
  /// **'Diagnose & monitor'**
  String get sectionDiagnose;

  /// No description provided for @sectionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get sectionComingSoon;

  /// No description provided for @toolDiseaseSub.
  ///
  /// In en, this message translates to:
  /// **'Photo → disease, severity & treatment'**
  String get toolDiseaseSub;

  /// No description provided for @toolSatelliteSub.
  ///
  /// In en, this message translates to:
  /// **'NDVI, water stress & flood mapping'**
  String get toolSatelliteSub;

  /// No description provided for @toolSoilSub.
  ///
  /// In en, this message translates to:
  /// **'Crop suitability, NPK & fertilizer plan'**
  String get toolSoilSub;

  /// No description provided for @toolWeatherSub.
  ///
  /// In en, this message translates to:
  /// **'Forecasts & alerts, explained in Bangla'**
  String get toolWeatherSub;

  /// No description provided for @comingDroneTitle.
  ///
  /// In en, this message translates to:
  /// **'Drone Crop Monitoring'**
  String get comingDroneTitle;

  /// No description provided for @comingDroneSub.
  ///
  /// In en, this message translates to:
  /// **'Aerial field scans — on the roadmap'**
  String get comingDroneSub;

  /// No description provided for @comingIotTitle.
  ///
  /// In en, this message translates to:
  /// **'IoT Soil Sensors'**
  String get comingIotTitle;

  /// No description provided for @comingIotSub.
  ///
  /// In en, this message translates to:
  /// **'Live soil readings — on the roadmap'**
  String get comingIotSub;

  /// No description provided for @comingLivestockTitle.
  ///
  /// In en, this message translates to:
  /// **'Livestock Assistant'**
  String get comingLivestockTitle;

  /// No description provided for @comingLivestockSub.
  ///
  /// In en, this message translates to:
  /// **'Cattle & poultry care — on the roadmap'**
  String get comingLivestockSub;

  /// No description provided for @marketTitle.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get marketTitle;

  /// No description provided for @marketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s prices across Bangladesh\'s wholesale markets'**
  String get marketSubtitle;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryGrains.
  ///
  /// In en, this message translates to:
  /// **'Grains'**
  String get categoryGrains;

  /// No description provided for @categoryVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get categoryVegetables;

  /// No description provided for @categoryCashCrops.
  ///
  /// In en, this message translates to:
  /// **'Cash crops'**
  String get categoryCashCrops;

  /// No description provided for @categoryPulses.
  ///
  /// In en, this message translates to:
  /// **'Pulses'**
  String get categoryPulses;

  /// No description provided for @categoryFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get categoryFruits;

  /// No description provided for @pricePerKg.
  ///
  /// In en, this message translates to:
  /// **'৳ {price}/kg'**
  String pricePerKg(String price);

  /// No description provided for @marketplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplaceTitle;

  /// No description provided for @marketplaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Buy inputs, rent machinery and sell your harvest to verified buyers — coming with the next release.'**
  String get marketplaceSubtitle;

  /// No description provided for @mpInputsTitle.
  ///
  /// In en, this message translates to:
  /// **'Seeds, fertilizers & pesticides'**
  String get mpInputsTitle;

  /// No description provided for @mpInputsSub.
  ///
  /// In en, this message translates to:
  /// **'Verified agri-input sellers'**
  String get mpInputsSub;

  /// No description provided for @mpMachineryTitle.
  ///
  /// In en, this message translates to:
  /// **'Machinery rental'**
  String get mpMachineryTitle;

  /// No description provided for @mpMachinerySub.
  ///
  /// In en, this message translates to:
  /// **'Tractors, harvesters, pumps'**
  String get mpMachinerySub;

  /// No description provided for @mpSellTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell your harvest'**
  String get mpSellTitle;

  /// No description provided for @mpSellSub.
  ///
  /// In en, this message translates to:
  /// **'Direct to verified buyers, fair prices'**
  String get mpSellSub;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make KrishiBondhu yours'**
  String get settingsSubtitle;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language · ভাষা'**
  String get sectionLanguage;

  /// No description provided for @languageNote.
  ///
  /// In en, this message translates to:
  /// **'The interface switches instantly when you change language.'**
  String get languageNote;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync your farm profile across devices'**
  String get signInSubtitle;

  /// No description provided for @accountToast.
  ///
  /// In en, this message translates to:
  /// **'Accounts arrive with the backend launch 🌱'**
  String get accountToast;

  /// No description provided for @sectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sectionNotifications;

  /// No description provided for @notifWeatherAlerts.
  ///
  /// In en, this message translates to:
  /// **'Weather & flood alerts'**
  String get notifWeatherAlerts;

  /// No description provided for @notifPriceUpdates.
  ///
  /// In en, this message translates to:
  /// **'Daily market prices'**
  String get notifPriceUpdates;

  /// No description provided for @notifCropReminders.
  ///
  /// In en, this message translates to:
  /// **'Crop care reminders'**
  String get notifCropReminders;

  /// No description provided for @quickMenuAllSettings.
  ///
  /// In en, this message translates to:
  /// **'All settings'**
  String get quickMenuAllSettings;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Empowering Bangladesh\'s agriculture through localized AI, satellite intelligence and voice-first interaction. Made for Bangladesh 🇧🇩'**
  String get aboutDescription;

  /// No description provided for @diseaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Disease Scan'**
  String get diseaseTitle;

  /// No description provided for @diseaseIntro.
  ///
  /// In en, this message translates to:
  /// **'Take or upload a clear photo of the affected leaf, stem or fruit. The AI identifies the disease and recommends treatment.'**
  String get diseaseIntro;

  /// No description provided for @noPhotoSelected.
  ///
  /// In en, this message translates to:
  /// **'No photo selected'**
  String get noPhotoSelected;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @analyzePhoto.
  ///
  /// In en, this message translates to:
  /// **'Analyze Photo'**
  String get analyzePhoto;

  /// No description provided for @detectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Detected'**
  String get detectedLabel;

  /// No description provided for @confidenceChip.
  ///
  /// In en, this message translates to:
  /// **'{percent}% confidence'**
  String confidenceChip(String percent);

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity: '**
  String get severityLabel;

  /// No description provided for @organicTreatment.
  ///
  /// In en, this message translates to:
  /// **'Organic treatment'**
  String get organicTreatment;

  /// No description provided for @chemicalTreatment.
  ///
  /// In en, this message translates to:
  /// **'Chemical treatment'**
  String get chemicalTreatment;

  /// No description provided for @prevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get prevention;

  /// No description provided for @scanAnother.
  ///
  /// In en, this message translates to:
  /// **'Scan another photo'**
  String get scanAnother;

  /// No description provided for @satelliteTitle.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get satelliteTitle;

  /// No description provided for @satelliteIntro.
  ///
  /// In en, this message translates to:
  /// **'Field intelligence from Sentinel-2 and Landsat imagery, analyzed for your district.'**
  String get satelliteIntro;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'DISTRICT'**
  String get districtLabel;

  /// No description provided for @districtSuffix.
  ///
  /// In en, this message translates to:
  /// **'{district} District'**
  String districtSuffix(String district);

  /// No description provided for @waterStress.
  ///
  /// In en, this message translates to:
  /// **'Water stress'**
  String get waterStress;

  /// No description provided for @floodRisk.
  ///
  /// In en, this message translates to:
  /// **'Flood risk'**
  String get floodRisk;

  /// No description provided for @yieldEstimate.
  ///
  /// In en, this message translates to:
  /// **'Yield estimate'**
  String get yieldEstimate;

  /// No description provided for @soilTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil'**
  String get soilTitle;

  /// No description provided for @soilIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your village, upazila or GPS coordinates. The AI predicts soil properties and the best crops for your land.'**
  String get soilIntro;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bogura Sadar or 24.85, 89.37'**
  String get locationPlaceholder;

  /// No description provided for @analyzeSoil.
  ///
  /// In en, this message translates to:
  /// **'Analyze Soil'**
  String get analyzeSoil;

  /// No description provided for @soilReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Report · {location}'**
  String soilReportTitle(String location);

  /// No description provided for @recommendedCropLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended crop'**
  String get recommendedCropLabel;

  /// No description provided for @expectedYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected yield: {value}'**
  String expectedYieldLabel(String value);

  /// No description provided for @fertilizerPlan.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer plan'**
  String get fertilizerPlan;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherTitle;

  /// No description provided for @weatherIntro.
  ///
  /// In en, this message translates to:
  /// **'BMD, NASA and OpenWeather combined — explained in simple Bangla, not just numbers.'**
  String get weatherIntro;

  /// No description provided for @districtToday.
  ///
  /// In en, this message translates to:
  /// **'{district} · Today'**
  String districtToday(String district);

  /// No description provided for @humidityChip.
  ///
  /// In en, this message translates to:
  /// **'💧 {percent}% humidity'**
  String humidityChip(String percent);

  /// No description provided for @rainChip.
  ///
  /// In en, this message translates to:
  /// **'🌧️ {percent}% rain'**
  String rainChip(String percent);

  /// No description provided for @advisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'আজকের পরামর্শ'**
  String get advisoryTitle;

  /// No description provided for @districtRangpur.
  ///
  /// In en, this message translates to:
  /// **'Rangpur'**
  String get districtRangpur;

  /// No description provided for @districtDhaka.
  ///
  /// In en, this message translates to:
  /// **'Dhaka'**
  String get districtDhaka;

  /// No description provided for @districtBogura.
  ///
  /// In en, this message translates to:
  /// **'Bogura'**
  String get districtBogura;

  /// No description provided for @districtRajshahi.
  ///
  /// In en, this message translates to:
  /// **'Rajshahi'**
  String get districtRajshahi;

  /// No description provided for @districtKhulna.
  ///
  /// In en, this message translates to:
  /// **'Khulna'**
  String get districtKhulna;

  /// No description provided for @districtSylhet.
  ///
  /// In en, this message translates to:
  /// **'Sylhet'**
  String get districtSylhet;

  /// No description provided for @districtChattogram.
  ///
  /// In en, this message translates to:
  /// **'Chattogram'**
  String get districtChattogram;

  /// No description provided for @districtBarishal.
  ///
  /// In en, this message translates to:
  /// **'Barishal'**
  String get districtBarishal;

  /// No description provided for @districtMymensingh.
  ///
  /// In en, this message translates to:
  /// **'Mymensingh'**
  String get districtMymensingh;

  /// No description provided for @districtDinajpur.
  ///
  /// In en, this message translates to:
  /// **'Dinajpur'**
  String get districtDinajpur;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String loadFailed(String error);

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed: {error}'**
  String analysisFailed(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
