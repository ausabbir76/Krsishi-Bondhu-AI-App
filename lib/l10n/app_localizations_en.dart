// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KrishiBondhu AI';

  @override
  String get tabHome => 'Home';

  @override
  String get tabAssistant => 'Assistant';

  @override
  String get tabTools => 'Tools';

  @override
  String get tabMarket => 'Market';

  @override
  String get tabSettings => 'Settings';

  @override
  String get heroChip => '🌾 Your AI Farming Companion';

  @override
  String get heroCountry => 'KrishiBondhu AI';

  @override
  String get heroHeadline => 'Bangla-Native\nAI Farming Assistant';

  @override
  String get heroDescription =>
      'Voice conversations, crop disease detection, satellite imagery, soil intelligence and weather forecasting — built for Bangladesh, in Bangla.';

  @override
  String get ctaScanCrop => 'Scan a Crop';

  @override
  String get ctaWeatherToday => 'Weather Today';

  @override
  String get statDetectionAccuracy => 'Detection accuracy';

  @override
  String get statAiAssistant => 'AI assistant';

  @override
  String get statSupportedCrops => 'Supported crops';

  @override
  String get modulesTitle => 'Six AI systems, one companion';

  @override
  String get modulesSubtitle =>
      'Every module is trained on Bangladesh\'s crops, weather and farming realities.';

  @override
  String get moduleVoiceTitle => 'AI Voice Assistant';

  @override
  String get moduleVoiceDesc =>
      'Speak in Bangla — natural conversations with memory and personalized advice.';

  @override
  String get moduleDiseaseTitle => 'Crop Disease Detection';

  @override
  String get moduleDiseaseDesc =>
      'Upload a photo. Get the disease, severity and treatment in seconds.';

  @override
  String get moduleSatelliteTitle => 'Satellite Intelligence';

  @override
  String get moduleSatelliteDesc =>
      'NDVI, water stress, flood mapping and yield estimates from Sentinel-2.';

  @override
  String get moduleSoilTitle => 'Soil Intelligence';

  @override
  String get moduleSoilDesc =>
      'GPS or soil report in — suitable crops, NPK, pH and fertilizer plan out.';

  @override
  String get moduleWeatherTitle => 'Weather Intelligence';

  @override
  String get moduleWeatherDesc =>
      'BMD, NASA and OpenWeather combined — explained in simple Bangla.';

  @override
  String get moduleMarketTitle => 'Marketplace';

  @override
  String get moduleMarketDesc =>
      'Verified buyers, machinery rental and daily market prices.';

  @override
  String get howTitle => 'Three steps. Any farm.';

  @override
  String get step1Title => 'Speak or upload';

  @override
  String get step1Desc =>
      'Ask a question in Bangla or upload a photo of your crop.';

  @override
  String get step2Title => 'AI understands';

  @override
  String get step2Desc =>
      'Analyzes weather, soil, satellite and agricultural knowledge for your farm.';

  @override
  String get step3Title => 'Get recommendations';

  @override
  String get step3Desc =>
      'Personalized guidance in Bangla — organic or chemical, whatever works.';

  @override
  String get cropsTitle => 'Supported crops';

  @override
  String get roadmapTitle => 'What\'s next';

  @override
  String get roadmapSubtitle =>
      'We\'re expanding beyond the phone — into the sky, the soil and the marketplace.';

  @override
  String get roadmapDrone => 'Drone monitoring';

  @override
  String get roadmapIot => 'IoT soil sensors';

  @override
  String get roadmapIrrigation => 'Smart irrigation';

  @override
  String get roadmapLivestock => 'Livestock assistant';

  @override
  String get roadmapPest => 'Pest prediction';

  @override
  String get roadmapInsurance => 'Crop insurance';

  @override
  String get cropRice => '🌾 Rice';

  @override
  String get cropMaize => '🌽 Maize';

  @override
  String get cropPotato => '🥔 Potato';

  @override
  String get cropTomato => '🍅 Tomato';

  @override
  String get cropCabbage => '🥬 Cabbage';

  @override
  String get cropChili => '🌶️ Chili';

  @override
  String get cropOnion => '🧅 Onion';

  @override
  String get cropCucumber => '🥒 Cucumber';

  @override
  String get cropEggplant => '🍆 Eggplant';

  @override
  String get cropLentil => '🫛 Lentil';

  @override
  String get cropJute => '🌱 Jute';

  @override
  String get cropBanana => '🍌 Banana';

  @override
  String get cropMango => '🥭 Mango';

  @override
  String get cropMustard => '🫘 Mustard';

  @override
  String get cropWatermelon => '🍉 Watermelon';

  @override
  String get assistantSubtitle =>
      'বাংলায় প্রশ্ন করুন — ask anything about your farm';

  @override
  String get assistantEmptyTitle => 'কৃষিবন্ধু এআই';

  @override
  String get assistantEmptySubtitle =>
      'Your farming questions, answered in Bangla.';

  @override
  String get tryAsking => 'TRY ASKING';

  @override
  String get chatPlaceholder => 'Type a question… / প্রশ্ন লিখুন…';

  @override
  String get micComingSoon => 'Bangla voice input is coming soon 🎙️';

  @override
  String chatError(String error) {
    return 'Sorry, something went wrong: $error';
  }

  @override
  String get chatHistoryTitle => 'Chats';

  @override
  String get chatHistorySubtitle => 'Your past conversations with KrishiBondhu';

  @override
  String get chatNew => 'New chat';

  @override
  String get chatDelete => 'Delete chat';

  @override
  String get chatAllChats => 'All chats';

  @override
  String get chatHistoryEmpty => 'No chats yet';

  @override
  String get chatHistoryEmptySub => 'Start a new conversation to see it here.';

  @override
  String chatMessageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages',
      one: '1 message',
    );
    return '$_temp0';
  }

  @override
  String get toolsTitle => 'AI Tools';

  @override
  String get toolsSubtitle =>
      'All KrishiBondhu intelligence modules in one place';

  @override
  String get sectionDiagnose => 'Diagnose & monitor';

  @override
  String get sectionComingSoon => 'Coming soon';

  @override
  String get toolDiseaseSub => 'Photo → disease, severity & treatment';

  @override
  String get toolSatelliteSub => 'NDVI, water stress & flood mapping';

  @override
  String get toolSoilSub => 'Crop suitability, NPK & fertilizer plan';

  @override
  String get toolWeatherSub => 'Forecasts & alerts, explained in Bangla';

  @override
  String get comingDroneTitle => 'Drone Crop Monitoring';

  @override
  String get comingDroneSub => 'Aerial field scans — on the roadmap';

  @override
  String get comingIotTitle => 'IoT Soil Sensors';

  @override
  String get comingIotSub => 'Live soil readings — on the roadmap';

  @override
  String get comingLivestockTitle => 'Livestock Assistant';

  @override
  String get comingLivestockSub => 'Cattle & poultry care — on the roadmap';

  @override
  String get marketTitle => 'Market';

  @override
  String get marketSubtitle =>
      'Today\'s prices across Bangladesh\'s wholesale markets';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryGrains => 'Grains';

  @override
  String get categoryVegetables => 'Vegetables';

  @override
  String get categoryCashCrops => 'Cash crops';

  @override
  String get categoryPulses => 'Pulses';

  @override
  String get categoryFruits => 'Fruits';

  @override
  String pricePerKg(String price) {
    return '৳ $price/kg';
  }

  @override
  String get marketplaceTitle => 'Marketplace';

  @override
  String get marketplaceSubtitle =>
      'Buy inputs, rent machinery and sell your harvest to verified buyers — coming with the next release.';

  @override
  String get mpInputsTitle => 'Seeds, fertilizers & pesticides';

  @override
  String get mpInputsSub => 'Verified agri-input sellers';

  @override
  String get mpMachineryTitle => 'Machinery rental';

  @override
  String get mpMachinerySub => 'Tractors, harvesters, pumps';

  @override
  String get mpSellTitle => 'Sell your harvest';

  @override
  String get mpSellSub => 'Direct to verified buyers, fair prices';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Make KrishiBondhu yours';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get sectionLanguage => 'Language · ভাষা';

  @override
  String get languageNote =>
      'The interface switches instantly when you change language.';

  @override
  String get sectionAccount => 'Account';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInSubtitle => 'Sync your farm profile across devices';

  @override
  String get accountToast => 'Accounts arrive with the backend launch 🌱';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get notifWeatherAlerts => 'Weather & flood alerts';

  @override
  String get notifPriceUpdates => 'Daily market prices';

  @override
  String get notifCropReminders => 'Crop care reminders';

  @override
  String get quickMenuAllSettings => 'All settings';

  @override
  String get sectionAbout => 'About';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'Empowering Bangladesh\'s agriculture through localized AI, satellite intelligence and voice-first interaction. Made for Bangladesh 🇧🇩';

  @override
  String get diseaseTitle => 'Disease Scan';

  @override
  String get diseaseIntro =>
      'Take or upload a clear photo of the affected leaf, stem or fruit. The AI identifies the disease and recommends treatment.';

  @override
  String get noPhotoSelected => 'No photo selected';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get analyzePhoto => 'Analyze Photo';

  @override
  String get detectedLabel => 'Detected';

  @override
  String confidenceChip(String percent) {
    return '$percent% confidence';
  }

  @override
  String get severityLabel => 'Severity: ';

  @override
  String get organicTreatment => 'Organic treatment';

  @override
  String get chemicalTreatment => 'Chemical treatment';

  @override
  String get prevention => 'Prevention';

  @override
  String get scanAnother => 'Scan another photo';

  @override
  String get satelliteTitle => 'Satellite';

  @override
  String get satelliteIntro =>
      'Field intelligence from Sentinel-2 and Landsat imagery, analyzed for your district.';

  @override
  String get districtLabel => 'DISTRICT';

  @override
  String districtSuffix(String district) {
    return '$district District';
  }

  @override
  String get waterStress => 'Water stress';

  @override
  String get floodRisk => 'Flood risk';

  @override
  String get yieldEstimate => 'Yield estimate';

  @override
  String get soilTitle => 'Soil';

  @override
  String get soilIntro =>
      'Enter your village, upazila or GPS coordinates. The AI predicts soil properties and the best crops for your land.';

  @override
  String get locationPlaceholder => 'e.g. Bogura Sadar or 24.85, 89.37';

  @override
  String get analyzeSoil => 'Analyze Soil';

  @override
  String soilReportTitle(String location) {
    return 'Soil Report · $location';
  }

  @override
  String get recommendedCropLabel => 'Recommended crop';

  @override
  String expectedYieldLabel(String value) {
    return 'Expected yield: $value';
  }

  @override
  String get fertilizerPlan => 'Fertilizer plan';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherIntro =>
      'BMD, NASA and OpenWeather combined — explained in simple Bangla, not just numbers.';

  @override
  String districtToday(String district) {
    return '$district · Today';
  }

  @override
  String humidityChip(String percent) {
    return '💧 $percent% humidity';
  }

  @override
  String rainChip(String percent) {
    return '🌧️ $percent% rain';
  }

  @override
  String get advisoryTitle => 'আজকের পরামর্শ';

  @override
  String get districtRangpur => 'Rangpur';

  @override
  String get districtDhaka => 'Dhaka';

  @override
  String get districtBogura => 'Bogura';

  @override
  String get districtRajshahi => 'Rajshahi';

  @override
  String get districtKhulna => 'Khulna';

  @override
  String get districtSylhet => 'Sylhet';

  @override
  String get districtChattogram => 'Chattogram';

  @override
  String get districtBarishal => 'Barishal';

  @override
  String get districtMymensingh => 'Mymensingh';

  @override
  String get districtDinajpur => 'Dinajpur';

  @override
  String loadFailed(String error) {
    return 'Failed to load: $error';
  }

  @override
  String analysisFailed(String error) {
    return 'Analysis failed: $error';
  }
}
