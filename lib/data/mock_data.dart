import '../models/complaint_model.dart';
import '../models/notice_model.dart';
import '../models/scheme_model.dart';

class MockData {
  // Citizen profile
  static const Map<String, dynamic> citizenProfile = {
    'id': 'citizen_001',
    'name': 'मयूर पाटील',
    'nameEn': 'Mayur Patil',
    'mobile': '9876543210',
    'panchayatName': 'नेर्ले ग्रामपंचायत',
    'panchayatNameEn': 'Nerle Gram Panchayat',
    'district': 'सांगली',
    'taluka': 'वेल्हे',
    'pendingDuesAmount': 1250.0,
    'unreadNotices': 3,
    'pendingComplaints': 2,
    'activeApplications': 1,
  };

  // Mock OTP
  static const String mockOtp = '123456';

  // Notices mock data
  static final List<Map<String, dynamic>> noticeMaps = [
    {
      'id': 'notice_001',
      'title': 'पूर सतर्कता — तातडीची सूचना',
      'titleEn': 'Flood Alert — Urgent Notice',
      'description':
          'कृष्णा नदीच्या पाणी पातळीत वाढ झाल्यामुळे नदीकाठच्या गावांना सतर्कतेचा इशारा देण्यात येत आहे.',
      'descriptionEn':
          'Due to rising water levels in Krishna river, riverside villages are on high alert.',
      'fullContent':
          'कृष्णा नदीच्या पाणी पातळीत मोठ्या प्रमाणात वाढ झाल्यामुळे नेर्ले ग्रामपंचायत क्षेत्रातील नदीकाठच्या सर्व नागरिकांना तातडीने सुरक्षित ठिकाणी जाण्याचे आवाहन करण्यात येत आहे.\n\nसर्व नागरिकांनी खालील सूचनांचे पालन करावे:\n• नदीकाठापासून किमान ५०० मीटर दूर राहावे.\n• आपले जनावरे व मौल्यवान वस्तू सुरक्षित ठिकाणी हलवाव्यात.\n• आपत्कालीन मदत केंद्र: ग्रामपंचायत कार्यालय, नेर्ले.\n• हेल्पलाइन: 1077\n\nकोणत्याही आपत्कालीन परिस्थितीत ग्रामसेवक यांच्याशी संपर्क साधावा.',
      'fullContentEn':
          'Due to a significant rise in Krishna river water levels, all citizens residing near the riverbank in Nerle Gram Panchayat area are urgently requested to move to safer locations.\n\nAll citizens must follow these instructions:\n• Stay at least 500 meters away from the riverbank.\n• Move livestock and valuables to safe locations.\n• Emergency relief centre: Gram Panchayat Office, Nerle.\n• Helpline: 1077\n\nIn case of any emergency, contact the Gram Sevak immediately.',
      'date': '2025-08-20',
      'category': 'emergency',
      'isUnread': true,
      'attachmentUrl': 'https://example.gov.in/flood-alert-2025.pdf',
      'attachmentName': 'Flood Alert Order 2025.pdf',
      'panchayatName': 'नेर्ले ग्रामपंचायत',
      'panchayatNameEn': 'Nerle Gram Panchayat',
      'district': 'सांगली',
      'taluka': 'वेल्हे',
      'issuedBy': 'ग्रामसेवक, नेर्ले',
    },
    {
      'id': 'notice_002',
      'title': 'मालमत्ता कर भरण्याची अंतिम तारीख',
      'titleEn': 'Property Tax Payment Deadline',
      'description':
          'मालमत्ता कर भरण्याची अंतिम तारीख ३१ ऑगस्ट २०२५ आहे. उशिरा भरल्यास दंड आकारला जाईल.',
      'descriptionEn':
          'Last date for property tax payment is 31 Aug 2025. Late payment will attract penalty.',
      'fullContent':
          'नेर्ले ग्रामपंचायत क्षेत्रातील सर्व मालमत्ताधारकांना सूचित करण्यात येते की, सन २०२५-२६ या वर्षाचा मालमत्ता कर भरण्याची अंतिम तारीख ३१ ऑगस्ट २०२५ आहे.\n\nमहत्त्वाची माहिती:\n• अंतिम तारखेनंतर भरल्यास दरमहा २% दंड आकारला जाईल.\n• कर भरणा ग्रामपंचायत कार्यालयात किंवा ऑनलाइन पोर्टलवर करता येईल.\n• कर भरणा वेळापत्रक: सोमवार ते शुक्रवार, सकाळी १० ते सायंकाळी ५.\n• अधिक माहितीसाठी: ०२३३-२३४५६७\n\nवेळेत कर भरून दंडापासून वाचा.',
      'fullContentEn':
          'All property owners in Nerle Gram Panchayat area are hereby informed that the last date for payment of property tax for the year 2025-26 is 31 August 2025.\n\nImportant information:\n• A penalty of 2% per month will be charged after the due date.\n• Tax can be paid at the Gram Panchayat office or online portal.\n• Payment schedule: Monday to Friday, 10 AM to 5 PM.\n• For more information: 0233-234567\n\nPay on time to avoid penalties.',
      'date': '2025-08-18',
      'category': 'important',
      'isUnread': true,
      'attachmentUrl': 'https://example.gov.in/tax-notice-2025.pdf',
      'attachmentName': 'Property Tax Notice 2025.pdf',
      'panchayatName': 'नेर्ले ग्रामपंचायत',
      'panchayatNameEn': 'Nerle Gram Panchayat',
      'district': 'सांगली',
      'taluka': 'वेल्हे',
      'issuedBy': 'सरपंच, नेर्ले ग्रामपंचायत',
    },
    {
      'id': 'notice_003',
      'title': 'ग्रामसभा बैठक — ऑगस्ट २०२५',
      'titleEn': 'Gram Sabha Meeting — August 2025',
      'description':
          'दि. २५ ऑगस्ट २०२५ रोजी सकाळी १० वाजता ग्रामसभा बैठक आयोजित केली आहे. सर्व नागरिकांनी उपस्थित राहावे.',
      'descriptionEn':
          'Gram Sabha meeting scheduled on 25 Aug 2025 at 10:00 AM. All citizens are requested to attend.',
      'fullContent':
          'नेर्ले ग्रामपंचायतीची त्रैमासिक ग्रामसभा बैठक दि. २५ ऑगस्ट २०२५ रोजी सकाळी १० वाजता ग्रामपंचायत कार्यालयात आयोजित करण्यात आली आहे.\n\nबैठकीचा अजेंडा:\n१. मागील बैठकीच्या इतिवृत्ताचे वाचन व मंजुरी\n२. ग्रामपंचायत वार्षिक अहवाल सादरीकरण\n३. पाणीपुरवठा योजनेचा आढावा\n४. रस्ते दुरुस्ती प्रस्ताव\n५. नवीन योजनांची माहिती\n६. इतर विषय\n\nसर्व नागरिकांनी आपले मतदार ओळखपत्र सोबत आणावे. बैठकीत सहभागी होणे हा आपला अधिकार आहे.',
      'fullContentEn':
          'The quarterly Gram Sabha meeting of Nerle Gram Panchayat is scheduled on 25 August 2025 at 10:00 AM at the Gram Panchayat office.\n\nAgenda:\n1. Reading and approval of previous meeting minutes\n2. Annual report presentation\n3. Water supply scheme review\n4. Road repair proposal\n5. Information on new schemes\n6. Other matters\n\nAll citizens are requested to bring their voter ID. Participation is your right.',
      'date': '2025-08-15',
      'category': 'government',
      'isUnread': true,
      'attachmentUrl': 'https://example.gov.in/gram-sabha-agenda-aug2025.pdf',
      'attachmentName': 'Gram Sabha Agenda Aug 2025.pdf',
      'panchayatName': 'नेर्ले ग्रामपंचायत',
      'panchayatNameEn': 'Nerle Gram Panchayat',
      'district': 'सांगली',
      'taluka': 'वेल्हे',
      'issuedBy': 'सरपंच, नेर्ले ग्रामपंचायत',
    },
    {
      'id': 'notice_004',
      'title': 'स्वातंत्र्य दिन सोहळा',
      'titleEn': 'Independence Day Celebration',
      'description':
          'दि. १५ ऑगस्ट २०२५ रोजी सकाळी ८ वाजता ध्वजारोहण व सांस्कृतिक कार्यक्रम आयोजित केला आहे.',
      'descriptionEn':
          'Flag hoisting and cultural programme on 15 Aug 2025 at 8:00 AM.',
      'fullContent':
          'नेर्ले ग्रामपंचायत तर्फे ७८ वा स्वातंत्र्य दिन सोहळा दि. १५ ऑगस्ट २०२५ रोजी सकाळी ८ वाजता ग्रामपंचायत मैदानावर आयोजित करण्यात आला आहे.\n\nकार्यक्रम वेळापत्रक:\n• सकाळी ८:०० — ध्वजारोहण\n• सकाळी ८:३० — राष्ट्रगीत\n• सकाळी ९:०० — सांस्कृतिक कार्यक्रम\n• सकाळी १०:०० — पारितोषिक वितरण\n\nशाळकरी मुले, महिला बचत गट, व ग्रामपंचायत कर्मचारी यांनी उपस्थित राहणे अनिवार्य आहे. सर्व नागरिकांचे स्वागत आहे.',
      'fullContentEn':
          'Nerle Gram Panchayat is organizing the 78th Independence Day celebration on 15 August 2025 at 8:00 AM at the Gram Panchayat ground.\n\nEvent schedule:\n• 8:00 AM — Flag hoisting\n• 8:30 AM — National Anthem\n• 9:00 AM — Cultural programme\n• 10:00 AM — Prize distribution\n\nAttendance is mandatory for school children, women self-help groups, and Gram Panchayat staff. All citizens are welcome.',
      'date': '2025-08-12',
      'category': 'event',
      'isUnread': false,
      'attachmentUrl': null,
      'attachmentName': null,
      'panchayatName': 'नेर्ले ग्रामपंचायत',
      'panchayatNameEn': 'Nerle Gram Panchayat',
      'district': 'सांगली',
      'taluka': 'वेल्हे',
      'issuedBy': 'ग्रामसेवक, नेर्ले',
    },
    {
      'id': 'notice_005',
      'title': 'पाणीपुरवठा वेळापत्रक',
      'titleEn': 'Water Supply Schedule',
      'description':
          'या आठवड्यात पाणीपुरवठा सकाळी ७ ते ९ या वेळात होईल. नागरिकांनी पाणी साठवून ठेवावे.',
      'descriptionEn':
          'Water supply this week: 7 AM to 9 AM daily. Citizens are advised to store water.',
      'fullContent':
          'नेर्ले ग्रामपंचायत क्षेत्रातील नागरिकांना सूचित करण्यात येते की, पाणी पुरवठा पंपाच्या दुरुस्तीमुळे या आठवड्यात पाणीपुरवठा मर्यादित वेळेत होईल.\n\nपाणीपुरवठा वेळापत्रक:\n• सोमवार ते शुक्रवार: सकाळी ७:०० ते ९:००\n• शनिवार: सकाळी ७:०० ते ८:३०\n• रविवार: पाणीपुरवठा बंद\n\nनागरिकांनी पुरेसे पाणी साठवून ठेवावे. दुरुस्तीचे काम दि. ३१ ऑगस्ट पर्यंत पूर्ण होण्याची अपेक्षा आहे. अधिक माहितीसाठी ग्रामपंचायत कार्यालयाशी संपर्क साधावा.',
      'fullContentEn':
          'Citizens of Nerle Gram Panchayat area are informed that due to pump maintenance, water supply will be available for limited hours this week.\n\nWater supply schedule:\n• Monday to Friday: 7:00 AM to 9:00 AM\n• Saturday: 7:00 AM to 8:30 AM\n• Sunday: No water supply\n\nCitizens are advised to store sufficient water. Repair work is expected to be completed by 31 August. For more information, contact the Gram Panchayat office.',
      'date': '2025-08-10',
      'category': 'general',
      'isUnread': false,
      'attachmentUrl': null,
      'attachmentName': null,
      'panchayatName': 'नेर्ले ग्रामपंचायत',
      'panchayatNameEn': 'Nerle Gram Panchayat',
      'district': 'सांगली',
      'taluka': 'वेल्हे',
      'issuedBy': 'ग्रामसेवक, नेर्ले',
    },
    {
      'id': 'notice_006',
      'title': 'प्रधानमंत्री आवास योजना — अर्ज आमंत्रण',
      'titleEn': 'PM Awas Yojana — Application Invitation',
      'description':
          'प्रधानमंत्री आवास योजनेअंतर्गत पात्र लाभार्थ्यांकडून अर्ज मागविण्यात येत आहेत.',
      'descriptionEn':
          'Applications are invited from eligible beneficiaries under PM Awas Yojana.',
      'fullContent':
          'महाराष्ट्र शासन, ग्रामविकास विभागाच्या निर्देशानुसार नेर्ले ग्रामपंचायत क्षेत्रातील पात्र लाभार्थ्यांकडून प्रधानमंत्री आवास योजना (ग्रामीण) अंतर्गत अर्ज मागविण्यात येत आहेत.\n\nपात्रता निकष:\n• कुटुंबाचे वार्षिक उत्पन्न ₹१,८०,००० पेक्षा कमी असावे\n• कुटुंबाकडे स्वतःचे घर नसावे\n• बीपीएल यादीत नाव असणे आवश्यक\n\nआवश्यक कागदपत्रे:\n• आधार कार्ड\n• उत्पन्नाचा दाखला\n• रेशन कार्ड\n• जमीन नसल्याचा दाखला\n\nअर्ज करण्याची अंतिम तारीख: ३० सप्टेंबर २०२५\nअर्ज ग्रामपंचायत कार्यालयात उपलब्ध आहेत.',
      'fullContentEn':
          'As per directions from Maharashtra Government, Rural Development Department, applications are invited from eligible beneficiaries in Nerle Gram Panchayat area under PM Awas Yojana (Gramin).\n\nEligibility criteria:\n• Annual family income less than ₹1,80,000\n• Family should not own a house\n• Name must be in BPL list\n\nRequired documents:\n• Aadhaar Card\n• Income Certificate\n• Ration Card\n• Certificate of no land ownership\n\nLast date for application: 30 September 2025\nApplication forms available at Gram Panchayat office.',
      'date': '2025-08-05',
      'category': 'government',
      'isUnread': false,
      'attachmentUrl': 'https://example.gov.in/pmay-application-form.pdf',
      'attachmentName': 'PMAY Application Form.pdf',
      'panchayatName': 'नेर्ले ग्रामपंचायत',
      'panchayatNameEn': 'Nerle Gram Panchayat',
      'district': 'सांगली',
      'taluka': 'वेल्हे',
      'issuedBy': 'सरपंच, नेर्ले ग्रामपंचायत',
    },
  ];

  // Services mock data
  static final List<Map<String, dynamic>> serviceMaps = [
    // ── Certificates ──
    {
      'id': 'svc_001',
      'nameMr': 'जन्म दाखला',
      'nameEn': 'Birth Certificate',
      'description': 'जन्म नोंदणी व दाखला मिळवा',
      'descriptionEn':
          'Register birth and obtain official birth certificate from Gram Panchayat.',
      'iconName': 'child_care',
      'colorHex': '#ff8100',
      'category': 'certificate',
      'processingDays': 7,
      'fee': 50.0,
      'eligibilityMr': 'ग्रामपंचायत क्षेत्रात जन्मलेल्या व्यक्तींसाठी',
      'eligibilityEn': 'For persons born within the Gram Panchayat area',
      'requiredDocuments': [
        'रुग्णालय जन्म प्रमाणपत्र / Hospital Birth Record',
        'आई-वडिलांचे आधार कार्ड / Parents Aadhaar Card',
        'रेशन कार्ड / Ration Card',
      ],
      'formFields': [
        {
          'id': 'child_name',
          'labelMr': 'मुलाचे नाव',
          'labelEn': 'Child Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'dob',
          'labelMr': 'जन्म तारीख',
          'labelEn': 'Date of Birth',
          'type': 'date',
          'required': true,
        },
        {
          'id': 'gender',
          'labelMr': 'लिंग',
          'labelEn': 'Gender',
          'type': 'radio',
          'required': true,
          'options': ['मुलगा / Male', 'मुलगी / Female', 'इतर / Other'],
        },
        {
          'id': 'father_name',
          'labelMr': 'वडिलांचे नाव',
          'labelEn': 'Father Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'mother_name',
          'labelMr': 'आईचे नाव',
          'labelEn': 'Mother Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'birth_place',
          'labelMr': 'जन्म ठिकाण',
          'labelEn': 'Place of Birth',
          'type': 'dropdown',
          'required': true,
          'options': ['रुग्णालय / Hospital', 'घर / Home', 'इतर / Other'],
        },
        {
          'id': 'hospital_cert',
          'labelMr': 'रुग्णालय प्रमाणपत्र',
          'labelEn': 'Hospital Certificate',
          'type': 'document',
          'required': true,
        },
        {
          'id': 'applicant_photo',
          'labelMr': 'अर्जदाराचा फोटो',
          'labelEn': 'Applicant Photo',
          'type': 'photo',
          'required': false,
        },
      ],
    },
    {
      'id': 'svc_002',
      'nameMr': 'मृत्यू दाखला',
      'nameEn': 'Death Certificate',
      'description': 'मृत्यू नोंदणी व दाखला मिळवा',
      'descriptionEn':
          'Register death and obtain official death certificate from Gram Panchayat.',
      'iconName': 'assignment',
      'colorHex': '#37474F',
      'category': 'certificate',
      'processingDays': 7,
      'fee': 50.0,
      'eligibilityMr': 'मृत व्यक्तीच्या कुटुंबातील सदस्य',
      'eligibilityEn': 'Family member of the deceased person',
      'requiredDocuments': [
        'रुग्णालय मृत्यू प्रमाणपत्र / Hospital Death Record',
        'मृत व्यक्तीचे आधार कार्ड / Deceased Aadhaar Card',
        'अर्जदाराचे ओळखपत्र / Applicant ID Proof',
      ],
      'formFields': [
        {
          'id': 'deceased_name',
          'labelMr': 'मृत व्यक्तीचे नाव',
          'labelEn': 'Deceased Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'dod',
          'labelMr': 'मृत्यू तारीख',
          'labelEn': 'Date of Death',
          'type': 'date',
          'required': true,
        },
        {
          'id': 'cause',
          'labelMr': 'मृत्यूचे कारण',
          'labelEn': 'Cause of Death',
          'type': 'dropdown',
          'required': true,
          'options': [
            'नैसर्गिक / Natural',
            'अपघात / Accident',
            'आजार / Illness',
            'इतर / Other',
          ],
        },
        {
          'id': 'applicant_name',
          'labelMr': 'अर्जदाराचे नाव',
          'labelEn': 'Applicant Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'relation',
          'labelMr': 'नाते',
          'labelEn': 'Relation',
          'type': 'dropdown',
          'required': true,
          'options': [
            'पती/पत्नी / Spouse',
            'मुलगा/मुलगी / Child',
            'भाऊ/बहीण / Sibling',
            'इतर / Other',
          ],
        },
        {
          'id': 'death_cert',
          'labelMr': 'मृत्यू प्रमाणपत्र',
          'labelEn': 'Death Record',
          'type': 'document',
          'required': true,
        },
      ],
    },
    {
      'id': 'svc_003',
      'nameMr': 'रहिवासी दाखला',
      'nameEn': 'Residence Certificate',
      'description': 'रहिवासी पुरावा दाखला मिळवा',
      'descriptionEn':
          'Get official proof of residence certificate from Gram Panchayat.',
      'iconName': 'home_work',
      'colorHex': '#2E7D32',
      'category': 'certificate',
      'processingDays': 5,
      'fee': 30.0,
      'eligibilityMr': 'किमान ३ वर्षे ग्रामपंचायत क्षेत्रात राहणारे नागरिक',
      'eligibilityEn':
          'Citizens residing in Gram Panchayat area for at least 3 years',
      'requiredDocuments': [
        'आधार कार्ड / Aadhaar Card',
        'रेशन कार्ड / Ration Card',
        'वीज बिल / Electricity Bill',
      ],
      'formFields': [
        {
          'id': 'full_name',
          'labelMr': 'पूर्ण नाव',
          'labelEn': 'Full Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'address',
          'labelMr': 'पत्ता',
          'labelEn': 'Address',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'years_residing',
          'labelMr': 'राहण्याचा कालावधी (वर्षे)',
          'labelEn': 'Years Residing',
          'type': 'number',
          'required': true,
        },
        {
          'id': 'purpose',
          'labelMr': 'उद्देश',
          'labelEn': 'Purpose',
          'type': 'dropdown',
          'required': true,
          'options': [
            'शाळा प्रवेश / School Admission',
            'नोकरी / Employment',
            'बँक / Bank',
            'सरकारी योजना / Govt Scheme',
            'इतर / Other',
          ],
        },
        {
          'id': 'aadhaar_doc',
          'labelMr': 'आधार कार्ड',
          'labelEn': 'Aadhaar Card',
          'type': 'document',
          'required': true,
        },
      ],
    },
    {
      'id': 'svc_004',
      'nameMr': 'उत्पन्न दाखला',
      'nameEn': 'Income Certificate',
      'description': 'उत्पन्नाचा दाखला मिळवा',
      'descriptionEn':
          'Get official income proof certificate for government schemes and admissions.',
      'iconName': 'account_balance_wallet',
      'colorHex': '#E65100',
      'category': 'certificate',
      'processingDays': 10,
      'fee': 30.0,
      'eligibilityMr': 'ग्रामपंचायत क्षेत्रातील कोणताही नागरिक',
      'eligibilityEn': 'Any citizen within the Gram Panchayat area',
      'requiredDocuments': [
        'आधार कार्ड / Aadhaar Card',
        'रेशन कार्ड / Ration Card',
        'उत्पन्नाचा पुरावा / Income Proof',
      ],
      'formFields': [
        {
          'id': 'full_name',
          'labelMr': 'पूर्ण नाव',
          'labelEn': 'Full Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'annual_income',
          'labelMr': 'वार्षिक उत्पन्न (₹)',
          'labelEn': 'Annual Income (₹)',
          'type': 'number',
          'required': true,
        },
        {
          'id': 'occupation',
          'labelMr': 'व्यवसाय',
          'labelEn': 'Occupation',
          'type': 'dropdown',
          'required': true,
          'options': [
            'शेती / Farming',
            'नोकरी / Service',
            'व्यापार / Business',
            'मजुरी / Labour',
            'इतर / Other',
          ],
        },
        {
          'id': 'purpose',
          'labelMr': 'उद्देश',
          'labelEn': 'Purpose',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'income_proof',
          'labelMr': 'उत्पन्नाचा पुरावा',
          'labelEn': 'Income Proof Document',
          'type': 'document',
          'required': true,
        },
      ],
    },
    // ── Water ──
    {
      'id': 'svc_005',
      'nameMr': 'नवीन पाणी कनेक्शन',
      'nameEn': 'New Water Connection',
      'description': 'नवीन पाणी कनेक्शनसाठी अर्ज करा',
      'descriptionEn':
          'Apply for a new water supply connection to your property.',
      'iconName': 'water',
      'colorHex': '#0277BD',
      'category': 'water',
      'processingDays': 15,
      'fee': 200.0,
      'eligibilityMr': 'ग्रामपंचायत क्षेत्रातील मालमत्ता धारक',
      'eligibilityEn': 'Property owners within the Gram Panchayat area',
      'requiredDocuments': [
        'मालमत्ता कागदपत्रे / Property Documents',
        'आधार कार्ड / Aadhaar Card',
        'साइट प्लान / Site Plan',
      ],
      'formFields': [
        {
          'id': 'owner_name',
          'labelMr': 'मालकाचे नाव',
          'labelEn': 'Owner Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'property_address',
          'labelMr': 'मालमत्तेचा पत्ता',
          'labelEn': 'Property Address',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'connection_type',
          'labelMr': 'कनेक्शन प्रकार',
          'labelEn': 'Connection Type',
          'type': 'radio',
          'required': true,
          'options': ['घरगुती / Domestic', 'व्यावसायिक / Commercial'],
        },
        {
          'id': 'pipe_size',
          'labelMr': 'पाईप आकार',
          'labelEn': 'Pipe Size',
          'type': 'dropdown',
          'required': true,
          'options': ['१/२ इंच', '३/४ इंच', '१ इंच'],
        },
        {
          'id': 'property_doc',
          'labelMr': 'मालमत्ता कागदपत्र',
          'labelEn': 'Property Document',
          'type': 'document',
          'required': true,
        },
      ],
    },
    {
      'id': 'svc_006',
      'nameMr': 'पाणी कर भरणा',
      'nameEn': 'Water Tax Payment',
      'description': 'पाणी कर भरा व कनेक्शन सुरू ठेवा',
      'descriptionEn':
          'Pay water tax and maintain your water supply connection.',
      'iconName': 'water_drop',
      'colorHex': '#0288D1',
      'category': 'water',
      'processingDays': 1,
      'fee': 0.0,
      'eligibilityMr': 'पाणी कनेक्शन असलेले सर्व नागरिक',
      'eligibilityEn': 'All citizens with active water connections',
      'requiredDocuments': [
        'पाणी बिल / Water Bill',
        'आधार कार्ड / Aadhaar Card',
      ],
      'formFields': [
        {
          'id': 'connection_no',
          'labelMr': 'कनेक्शन नंबर',
          'labelEn': 'Connection Number',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'consumer_name',
          'labelMr': 'ग्राहकाचे नाव',
          'labelEn': 'Consumer Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'amount',
          'labelMr': 'रक्कम (₹)',
          'labelEn': 'Amount (₹)',
          'type': 'number',
          'required': true,
        },
        {
          'id': 'payment_mode',
          'labelMr': 'पेमेंट पद्धत',
          'labelEn': 'Payment Mode',
          'type': 'dropdown',
          'required': true,
          'options': ['रोख / Cash', 'UPI', 'नेट बँकिंग / Net Banking'],
        },
      ],
    },
    // ── Property/Tax ──
    {
      'id': 'svc_007',
      'nameMr': 'मालमत्ता कर',
      'nameEn': 'Property Tax',
      'description': 'मालमत्ता कर भरा व पावती मिळवा',
      'descriptionEn':
          'Pay property tax and get official receipt from Gram Panchayat.',
      'iconName': 'villa',
      'colorHex': '#6A1B9A',
      'category': 'tax',
      'processingDays': 1,
      'fee': 0.0,
      'eligibilityMr': 'ग्रामपंचायत क्षेत्रातील सर्व मालमत्ता धारक',
      'eligibilityEn': 'All property owners within the Gram Panchayat area',
      'requiredDocuments': [
        'मालमत्ता कर बिल / Property Tax Bill',
        'आधार कार्ड / Aadhaar Card',
      ],
      'formFields': [
        {
          'id': 'property_no',
          'labelMr': 'मालमत्ता क्रमांक',
          'labelEn': 'Property Number',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'owner_name',
          'labelMr': 'मालकाचे नाव',
          'labelEn': 'Owner Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'tax_year',
          'labelMr': 'कर वर्ष',
          'labelEn': 'Tax Year',
          'type': 'dropdown',
          'required': true,
          'options': ['2024-25', '2023-24', '2022-23'],
        },
        {
          'id': 'amount',
          'labelMr': 'रक्कम (₹)',
          'labelEn': 'Amount (₹)',
          'type': 'number',
          'required': true,
        },
        {
          'id': 'payment_mode',
          'labelMr': 'पेमेंट पद्धत',
          'labelEn': 'Payment Mode',
          'type': 'dropdown',
          'required': true,
          'options': ['रोख / Cash', 'UPI', 'नेट बँकिंग / Net Banking'],
        },
      ],
    },
    // ── Applications ──
    {
      'id': 'svc_008',
      'nameMr': 'बांधकाम परवाना',
      'nameEn': 'Building Permit',
      'description': 'नवीन बांधकामासाठी परवाना मिळवा',
      'descriptionEn':
          'Get official permit for new construction or renovation work.',
      'iconName': 'construction',
      'colorHex': '#BF360C',
      'category': 'applications',
      'processingDays': 30,
      'fee': 500.0,
      'eligibilityMr': 'ग्रामपंचायत क्षेत्रातील जमीन मालक',
      'eligibilityEn': 'Land owners within the Gram Panchayat area',
      'requiredDocuments': [
        '७/१२ उतारा / 7/12 Extract',
        'नकाशा / Site Map',
        'आधार कार्ड / Aadhaar Card',
        'बांधकाम योजना / Building Plan',
      ],
      'formFields': [
        {
          'id': 'owner_name',
          'labelMr': 'मालकाचे नाव',
          'labelEn': 'Owner Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'plot_no',
          'labelMr': 'भूखंड क्रमांक',
          'labelEn': 'Plot Number',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'construction_type',
          'labelMr': 'बांधकाम प्रकार',
          'labelEn': 'Construction Type',
          'type': 'dropdown',
          'required': true,
          'options': [
            'नवीन घर / New House',
            'विस्तार / Extension',
            'दुरुस्ती / Renovation',
            'व्यावसायिक / Commercial',
          ],
        },
        {
          'id': 'area_sqft',
          'labelMr': 'क्षेत्रफळ (चौ.फूट)',
          'labelEn': 'Area (sq.ft)',
          'type': 'number',
          'required': true,
        },
        {
          'id': 'floors',
          'labelMr': 'मजले',
          'labelEn': 'Number of Floors',
          'type': 'number',
          'required': true,
        },
        {
          'id': 'seven_twelve',
          'labelMr': '७/१२ उतारा',
          'labelEn': '7/12 Extract',
          'type': 'document',
          'required': true,
        },
        {
          'id': 'building_plan',
          'labelMr': 'बांधकाम योजना',
          'labelEn': 'Building Plan',
          'type': 'document',
          'required': true,
        },
      ],
    },
    {
      'id': 'svc_009',
      'nameMr': 'व्यापार परवाना',
      'nameEn': 'Trade License',
      'description': 'व्यापार/दुकान परवान्यासाठी अर्ज करा',
      'descriptionEn':
          'Apply for trade or shop license to operate business in the area.',
      'iconName': 'receipt_long',
      'colorHex': '#00695C',
      'category': 'applications',
      'processingDays': 21,
      'fee': 300.0,
      'eligibilityMr': 'ग्रामपंचायत क्षेत्रात व्यवसाय करणारे',
      'eligibilityEn': 'Business operators within the Gram Panchayat area',
      'requiredDocuments': [
        'आधार कार्ड / Aadhaar Card',
        'दुकान पत्ता पुरावा / Shop Address Proof',
        'पासपोर्ट फोटो / Passport Photo',
      ],
      'formFields': [
        {
          'id': 'business_name',
          'labelMr': 'व्यवसायाचे नाव',
          'labelEn': 'Business Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'owner_name',
          'labelMr': 'मालकाचे नाव',
          'labelEn': 'Owner Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'business_type',
          'labelMr': 'व्यवसाय प्रकार',
          'labelEn': 'Business Type',
          'type': 'dropdown',
          'required': true,
          'options': [
            'किराणा / Grocery',
            'हॉटेल / Hotel',
            'कपडे / Clothing',
            'इलेक्ट्रॉनिक्स / Electronics',
            'इतर / Other',
          ],
        },
        {
          'id': 'shop_address',
          'labelMr': 'दुकानाचा पत्ता',
          'labelEn': 'Shop Address',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'owner_photo',
          'labelMr': 'मालकाचा फोटो',
          'labelEn': 'Owner Photo',
          'type': 'photo',
          'required': true,
        },
        {
          'id': 'address_proof',
          'labelMr': 'पत्ता पुरावा',
          'labelEn': 'Address Proof',
          'type': 'document',
          'required': true,
        },
      ],
    },
    // ── Documents ──
    {
      'id': 'svc_010',
      'nameMr': 'जात प्रमाणपत्र',
      'nameEn': 'Caste Certificate',
      'description': 'जात प्रमाणपत्र मिळवा',
      'descriptionEn':
          'Obtain official caste certificate for government schemes and reservations.',
      'iconName': 'description',
      'colorHex': '#4527A0',
      'category': 'documents',
      'processingDays': 14,
      'fee': 20.0,
      'eligibilityMr': 'अनुसूचित जाती/जमाती व इतर मागासवर्गीय नागरिक',
      'eligibilityEn': 'SC/ST and OBC citizens',
      'requiredDocuments': [
        'आधार कार्ड / Aadhaar Card',
        'रेशन कार्ड / Ration Card',
        'शाळा सोडल्याचा दाखला / School Leaving Certificate',
      ],
      'formFields': [
        {
          'id': 'full_name',
          'labelMr': 'पूर्ण नाव',
          'labelEn': 'Full Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'caste',
          'labelMr': 'जात',
          'labelEn': 'Caste',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'category',
          'labelMr': 'प्रवर्ग',
          'labelEn': 'Category',
          'type': 'dropdown',
          'required': true,
          'options': [
            'SC / अनुसूचित जाती',
            'ST / अनुसूचित जमाती',
            'OBC / इतर मागासवर्गीय',
            'NT / भटक्या जमाती',
          ],
        },
        {
          'id': 'purpose',
          'labelMr': 'उद्देश',
          'labelEn': 'Purpose',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'aadhaar',
          'labelMr': 'आधार कार्ड',
          'labelEn': 'Aadhaar Card',
          'type': 'document',
          'required': true,
        },
        {
          'id': 'ration_card',
          'labelMr': 'रेशन कार्ड',
          'labelEn': 'Ration Card',
          'type': 'document',
          'required': true,
        },
      ],
    },
    {
      'id': 'svc_011',
      'nameMr': 'नमुना ८ उतारा',
      'nameEn': 'Form 8 Extract',
      'description': 'जमीन नोंदणी उतारा मिळवा',
      'descriptionEn':
          'Get land registration extract (Form 8) for property verification.',
      'iconName': 'folder_open',
      'colorHex': '#558B2F',
      'category': 'documents',
      'processingDays': 3,
      'fee': 25.0,
      'eligibilityMr': 'जमीन मालक किंवा अधिकृत प्रतिनिधी',
      'eligibilityEn': 'Land owner or authorized representative',
      'requiredDocuments': [
        'आधार कार्ड / Aadhaar Card',
        '७/१२ उतारा / 7/12 Extract',
      ],
      'formFields': [
        {
          'id': 'owner_name',
          'labelMr': 'मालकाचे नाव',
          'labelEn': 'Owner Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'survey_no',
          'labelMr': 'सर्वे नंबर',
          'labelEn': 'Survey Number',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'village',
          'labelMr': 'गाव',
          'labelEn': 'Village',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'purpose',
          'labelMr': 'उद्देश',
          'labelEn': 'Purpose',
          'type': 'dropdown',
          'required': true,
          'options': [
            'बँक कर्ज / Bank Loan',
            'विक्री / Sale',
            'सरकारी काम / Govt Work',
            'इतर / Other',
          ],
        },
        {
          'id': 'aadhaar',
          'labelMr': 'आधार कार्ड',
          'labelEn': 'Aadhaar Card',
          'type': 'document',
          'required': true,
        },
      ],
    },
    // ── Other Panchayat Services ──
    {
      'id': 'svc_012',
      'nameMr': 'इतर सेवा',
      'nameEn': 'Other Services',
      'description': 'अन्य ग्रामपंचायत सेवा',
      'descriptionEn': 'Other Gram Panchayat services not listed above.',
      'iconName': 'more_horiz',
      'colorHex': '#455A64',
      'category': 'other',
      'processingDays': 15,
      'fee': 0.0,
      'eligibilityMr': 'ग्रामपंचायत क्षेत्रातील कोणताही नागरिक',
      'eligibilityEn': 'Any citizen within the Gram Panchayat area',
      'requiredDocuments': [
        'आधार कार्ड / Aadhaar Card',
        'संबंधित कागदपत्रे / Relevant Documents',
      ],
      'formFields': [
        {
          'id': 'full_name',
          'labelMr': 'पूर्ण नाव',
          'labelEn': 'Full Name',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'service_desc',
          'labelMr': 'सेवेचे वर्णन',
          'labelEn': 'Service Description',
          'type': 'text',
          'required': true,
        },
        {
          'id': 'contact',
          'labelMr': 'संपर्क क्रमांक',
          'labelEn': 'Contact Number',
          'type': 'number',
          'required': true,
        },
        {
          'id': 'supporting_doc',
          'labelMr': 'संबंधित कागदपत्र',
          'labelEn': 'Supporting Document',
          'type': 'document',
          'required': false,
        },
      ],
    },
  ];

  // Quick actions
  static final List<Map<String, dynamic>> quickActions = [
    {
      'id': 'qa_services',
      'labelMr': 'सेवा',
      'labelEn': 'Services',
      'iconName': 'miscellaneous_services',
      'colorHex': '#ff8100',
      'route': '/services-screen',
    },
    {
      'id': 'qa_complaints',
      'labelMr': 'तक्रारी',
      'labelEn': 'Complaints',
      'iconName': 'report_problem',
      'colorHex': '#E65100',
      'route': '/complaints-screen',
    },
    {
      'id': 'qa_notices',
      'labelMr': 'सूचना',
      'labelEn': 'Notices',
      'iconName': 'campaign',
      'colorHex': '#2E7D32',
      'route': '/notices-screen',
    },
    {
      'id': 'qa_schemes',
      'labelMr': 'योजना',
      'labelEn': 'Schemes',
      'iconName': 'account_balance',
      'colorHex': '#6A1B9A',
      'route': '/schemes-screen',
    },
    {
      'id': 'qa_payments',
      'labelMr': 'पेमेंट',
      'labelEn': 'Payments',
      'iconName': 'payments',
      'colorHex': '#0277BD',
      'route': '/payment-summary',
    },
    {
      'id': 'qa_contacts',
      'labelMr': 'संपर्क',
      'labelEn': 'Contacts',
      'iconName': 'contacts',
      'colorHex': '#37474F',
      'route': '/citizen-profile',
    },
  ];

  // Upcoming events
  static final List<Map<String, dynamic>> upcomingEvents = [
    {
      'id': 'evt_001',
      'titleMr': 'ग्रामसभा बैठक',
      'titleEn': 'Gram Sabha Meeting',
      'date': '20 ऑगस्ट 2025',
      'time': 'सकाळी १० वाजता',
      'iconName': 'groups',
      'colorHex': '#ff8100',
    },
    {
      'id': 'evt_002',
      'titleMr': 'स्वच्छता अभियान',
      'titleEn': 'Cleanliness Drive',
      'date': '17 ऑगस्ट 2025',
      'time': 'सकाळी ८ वाजता',
      'iconName': 'cleaning_services',
      'colorHex': '#2E7D32',
    },
  ];

  // ── Mock Complaints ──
  static List<ComplaintModel> get mockComplaints => [
    ComplaintModel(
      id: 'cmp_001',
      complaintId: 'CMP2024001',
      category: ComplaintCategory.water,
      description:
          'वार्डात गेल्या ३ दिवसांपासून पाणीपुरवठा बंद आहे. कृपया लवकर दुरुस्ती करावी.',
      location: 'वार्ड नं. ३, नेर्ले गाव',
      currentStatus: ComplaintStatus.inProgress,
      submittedAt: DateTime(2024, 8, 10, 9, 30),
      timeline: [
        ComplaintTimelineEvent(
          status: ComplaintStatus.submitted,
          dateTime: DateTime(2024, 8, 10, 9, 30),
          officerRemark: 'तक्रार प्राप्त झाली. लवकरच कार्यवाही होईल.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.assigned,
          dateTime: DateTime(2024, 8, 10, 14, 0),
          officerName: 'श्री. राजेश पाटील',
          officerRemark: 'तक्रार जलविभाग अधिकाऱ्यांकडे सोपवली आहे.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.inProgress,
          dateTime: DateTime(2024, 8, 11, 10, 0),
          officerName: 'श्री. राजेश पाटील',
          officerRemark:
              'पाईप दुरुस्तीचे काम सुरू आहे. उद्यापर्यंत पूर्ण होईल.',
        ),
      ],
    ),
    ComplaintModel(
      id: 'cmp_002',
      complaintId: 'CMP2024002',
      category: ComplaintCategory.streetLights,
      description:
          'मुख्य रस्त्यावरील ५ पथदिवे गेल्या आठवड्यापासून बंद आहेत. रात्री अंधार असल्याने धोका आहे.',
      location: 'मुख्य बाजार रस्ता, नेर्ले',
      currentStatus: ComplaintStatus.resolved,
      submittedAt: DateTime(2024, 8, 5, 11, 0),
      canReopen: true,
      timeline: [
        ComplaintTimelineEvent(
          status: ComplaintStatus.submitted,
          dateTime: DateTime(2024, 8, 5, 11, 0),
          officerRemark: 'तक्रार नोंदवली.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.assigned,
          dateTime: DateTime(2024, 8, 5, 15, 30),
          officerName: 'श्री. सुनील देशमुख',
          officerRemark: 'विद्युत विभागाकडे पाठवले.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.inProgress,
          dateTime: DateTime(2024, 8, 6, 9, 0),
          officerName: 'श्री. सुनील देशमुख',
          officerRemark: 'पथदिवे दुरुस्तीचे काम सुरू.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.resolved,
          dateTime: DateTime(2024, 8, 7, 17, 0),
          officerName: 'श्री. सुनील देशमुख',
          officerRemark: 'सर्व ५ पथदिवे दुरुस्त करण्यात आले. कृपया तपासा.',
        ),
      ],
    ),
    ComplaintModel(
      id: 'cmp_003',
      complaintId: 'CMP2024003',
      category: ComplaintCategory.roads,
      description:
          'शाळेजवळील रस्त्यावर मोठे खड्डे आहेत. मुलांना शाळेत जाताना त्रास होतो.',
      location: 'जिल्हा परिषद शाळेजवळ, नेर्ले',
      currentStatus: ComplaintStatus.submitted,
      submittedAt: DateTime(2024, 8, 14, 8, 45),
      timeline: [
        ComplaintTimelineEvent(
          status: ComplaintStatus.submitted,
          dateTime: DateTime(2024, 8, 14, 8, 45),
          officerRemark: 'तक्रार प्राप्त झाली. लवकरच कार्यवाही होईल.',
        ),
      ],
    ),
    ComplaintModel(
      id: 'cmp_004',
      complaintId: 'CMP2024004',
      category: ComplaintCategory.garbage,
      description:
          'वार्ड नं. ७ मध्ये गेल्या ४ दिवसांपासून कचरा उचलला गेला नाही. दुर्गंधी येत आहे.',
      location: 'वार्ड नं. ७, नेर्ले गाव',
      currentStatus: ComplaintStatus.closed,
      submittedAt: DateTime(2024, 7, 28, 10, 0),
      rating: 4,
      timeline: [
        ComplaintTimelineEvent(
          status: ComplaintStatus.submitted,
          dateTime: DateTime(2024, 7, 28, 10, 0),
          officerRemark: 'तक्रार नोंदवली.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.assigned,
          dateTime: DateTime(2024, 7, 28, 13, 0),
          officerName: 'श्री. विकास जाधव',
          officerRemark: 'स्वच्छता विभागाकडे पाठवले.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.inProgress,
          dateTime: DateTime(2024, 7, 29, 7, 0),
          officerName: 'श्री. विकास जाधव',
          officerRemark: 'कचरा उचलण्याचे काम सुरू.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.resolved,
          dateTime: DateTime(2024, 7, 29, 11, 0),
          officerName: 'श्री. विकास जाधव',
          officerRemark: 'कचरा उचलण्यात आला. नियमित वेळापत्रक सुरू केले.',
        ),
        ComplaintTimelineEvent(
          status: ComplaintStatus.closed,
          dateTime: DateTime(2024, 7, 30, 9, 0),
          officerRemark: 'तक्रार बंद करण्यात आली.',
        ),
      ],
    ),
  ];

  static List<NoticeModel> get mockNotices =>
      noticeMaps.map((m) => NoticeModel.fromMap(m)).toList();

  // ── Mock Schemes ──
  static List<SchemeModel> get mockSchemes => [
    const SchemeModel(
      id: 'sch_001',
      nameMr: 'प्रधानमंत्री आवास योजना (ग्रामीण)',
      nameEn: 'PM Awas Yojana (Gramin)',
      department: 'ग्रामविकास मंत्रालय',
      departmentEn: 'Ministry of Rural Development',
      shortDescMr:
          'ग्रामीण गरीब कुटुंबांना पक्के घर बांधण्यासाठी आर्थिक सहाय्य',
      shortDescEn:
          'Financial assistance to rural poor families for constructing pucca houses',
      eligibilitySummaryMr: 'बेघर किंवा कच्च्या घरात राहणारे BPL कुटुंब',
      eligibilitySummaryEn: 'Homeless or BPL families living in kutcha houses',
      category: 'housing',
      aboutMr:
          'प्रधानमंत्री आवास योजना (ग्रामीण) ही केंद्र सरकारची एक प्रमुख योजना आहे. या योजनेंतर्गत ग्रामीण भागातील बेघर व कच्च्या घरात राहणाऱ्या गरीब कुटुंबांना पक्के घर बांधण्यासाठी आर्थिक सहाय्य दिले जाते. मैदानी भागात ₹१,२०,००० व डोंगराळ भागात ₹१,३०,००० अनुदान दिले जाते.',
      aboutEn:
          'PM Awas Yojana (Gramin) is a flagship scheme of the Central Government. Under this scheme, financial assistance is provided to homeless and poor families living in kutcha houses in rural areas to construct pucca houses. A grant of ₹1,20,000 in plain areas and ₹1,30,000 in hilly areas is provided.',
      whoCanApplyMr:
          'बेघर कुटुंब, एक किंवा दोन खोल्यांच्या कच्च्या घरात राहणारे कुटुंब, SC/ST, अल्पसंख्याक, माजी सैनिकांचे कुटुंब, विधवा महिला',
      whoCanApplyEn:
          'Homeless families, families living in kutcha houses with one or two rooms, SC/ST, minorities, ex-servicemen families, widows',
      benefitsMr:
          '• मैदानी भागात ₹१,२०,००० अनुदान\n• डोंगराळ भागात ₹१,३०,००० अनुदान\n• मनरेगाअंतर्गत ९० दिवस रोजगार\n• स्वच्छ भारत मिशनअंतर्गत शौचालय बांधणीसाठी ₹१२,०००',
      benefitsEn:
          '• Grant of ₹1,20,000 in plain areas\n• Grant of ₹1,30,000 in hilly areas\n• 90 days employment under MGNREGA\n• ₹12,000 for toilet construction under Swachh Bharat Mission',
      eligibilityMr:
          '• कुटुंबाचे वार्षिक उत्पन्न ₹१,८०,००० पेक्षा कमी असावे\n• BPL यादीत नाव असणे आवश्यक\n• कुटुंबाकडे स्वतःचे पक्के घर नसावे\n• आधार कार्ड असणे अनिवार्य',
      eligibilityEn:
          '• Annual family income less than ₹1,80,000\n• Name must be in BPL list\n• Family should not own a pucca house\n• Aadhaar card is mandatory',
      requiredDocuments: [
        'आधार कार्ड / Aadhaar Card',
        'BPL रेशन कार्ड / BPL Ration Card',
        'उत्पन्नाचा दाखला / Income Certificate',
        'जमीन नसल्याचा दाखला / No Land Certificate',
        'बँक पासबुक / Bank Passbook',
        'फोटो / Passport Size Photo',
      ],
      howToApplyMr:
          '१. ग्रामपंचायत कार्यालयात जाऊन अर्ज घ्या.\n२. सर्व आवश्यक कागदपत्रे जोडा.\n३. ग्रामसेवकाकडे अर्ज सादर करा.\n४. पात्रता तपासणीनंतर लाभार्थी यादीत नाव समाविष्ट केले जाईल.\n५. मंजुरीनंतर थेट बँक खात्यात रक्कम जमा होईल.',
      howToApplyEn:
          '1. Visit the Gram Panchayat office and collect the application form.\n2. Attach all required documents.\n3. Submit the application to the Gram Sevak.\n4. After eligibility verification, name will be included in the beneficiary list.\n5. After approval, amount will be directly credited to bank account.',
      officialSourceUrl: 'https://pmayg.nic.in',
      officialSourceLabel: 'pmayg.nic.in',
      lastUpdated: 'जुलै २०२५ / July 2025',
      informationSource:
          'ग्रामविकास मंत्रालय, भारत सरकार / Ministry of Rural Development, Govt. of India',
      applyUrl: 'https://pmayg.nic.in',
    ),
    const SchemeModel(
      id: 'sch_002',
      nameMr: 'महात्मा गांधी राष्ट्रीय ग्रामीण रोजगार हमी योजना',
      nameEn: 'MGNREGA',
      department: 'ग्रामविकास मंत्रालय',
      departmentEn: 'Ministry of Rural Development',
      shortDescMr: 'ग्रामीण कुटुंबांना वर्षातून किमान १०० दिवस रोजगाराची हमी',
      shortDescEn:
          'Guarantee of at least 100 days of employment per year to rural households',
      eligibilitySummaryMr:
          'ग्रामीण भागातील प्रौढ सदस्य जे अकुशल काम करण्यास तयार आहेत',
      eligibilitySummaryEn:
          'Adult members of rural households willing to do unskilled manual work',
      category: 'employment',
      aboutMr:
          'महात्मा गांधी राष्ट्रीय ग्रामीण रोजगार हमी योजना (मनरेगा) ही जगातील सर्वात मोठी रोजगार हमी योजना आहे. या योजनेंतर्गत ग्रामीण कुटुंबांना वर्षातून किमान १०० दिवस अकुशल काम देण्याची हमी दिली जाते.',
      aboutEn:
          'Mahatma Gandhi National Rural Employment Guarantee Act (MGNREGA) is the world\'s largest employment guarantee scheme. Under this scheme, rural households are guaranteed at least 100 days of unskilled work per year.',
      whoCanApplyMr:
          'ग्रामीण भागातील कोणताही प्रौढ (१८ वर्षांवरील) नागरिक जो अकुशल काम करण्यास तयार आहे',
      whoCanApplyEn:
          'Any adult (above 18 years) citizen of rural area willing to do unskilled manual work',
      benefitsMr:
          '• वर्षातून किमान १०० दिवस रोजगार\n• किमान वेतन दर लागू\n• १५ दिवसांत काम न मिळाल्यास बेरोजगारी भत्ता\n• काम घरापासून ५ किमी आत',
      benefitsEn:
          '• Minimum 100 days employment per year\n• Minimum wage rates applicable\n• Unemployment allowance if work not provided within 15 days\n• Work within 5 km from home',
      eligibilityMr:
          '• ग्रामीण भागात राहणारे असणे आवश्यक\n• वय १८ वर्षांपेक्षा जास्त असावे\n• जॉब कार्ड असणे आवश्यक\n• अकुशल काम करण्यास तयार असणे',
      eligibilityEn:
          '• Must be a resident of rural area\n• Age must be above 18 years\n• Must have a Job Card\n• Must be willing to do unskilled manual work',
      requiredDocuments: [
        'आधार कार्ड / Aadhaar Card',
        'रेशन कार्ड / Ration Card',
        'रहिवासी दाखला / Residence Certificate',
        'फोटो / Passport Size Photo',
        'बँक पासबुक / Bank Passbook',
      ],
      howToApplyMr:
          '१. ग्रामपंचायत कार्यालयात जाऊन जॉब कार्डसाठी अर्ज करा.\n२. आवश्यक कागदपत्रे सादर करा.\n३. जॉब कार्ड मिळाल्यावर कामाची मागणी करा.\n४. ग्रामपंचायत १५ दिवसांत काम देईल.',
      howToApplyEn:
          '1. Visit Gram Panchayat office and apply for Job Card.\n2. Submit required documents.\n3. After receiving Job Card, demand work.\n4. Gram Panchayat will provide work within 15 days.',
      officialSourceUrl: 'https://nrega.nic.in',
      officialSourceLabel: 'nrega.nic.in',
      lastUpdated: 'ऑगस्ट २०२५ / August 2025',
      informationSource:
          'ग्रामविकास मंत्रालय, भारत सरकार / Ministry of Rural Development, Govt. of India',
      applyUrl: 'https://nrega.nic.in',
    ),
    const SchemeModel(
      id: 'sch_003',
      nameMr: 'स्वच्छ भारत मिशन (ग्रामीण)',
      nameEn: 'Swachh Bharat Mission (Gramin)',
      department: 'पेयजल व स्वच्छता मंत्रालय',
      departmentEn: 'Ministry of Jal Shakti',
      shortDescMr:
          'शौचालय बांधणीसाठी ₹१२,००० अनुदान व खुल्या शौचमुक्त गावांसाठी प्रोत्साहन',
      shortDescEn:
          '₹12,000 grant for toilet construction and incentives for ODF villages',
      eligibilitySummaryMr: 'ज्या कुटुंबांकडे शौचालय नाही असे BPL व APL कुटुंब',
      eligibilitySummaryEn: 'BPL and APL families who do not have a toilet',
      category: 'sanitation',
      aboutMr:
          'स्वच्छ भारत मिशन (ग्रामीण) हे भारत सरकारचे एक महत्त्वाचे अभियान आहे. या अभियानाचे उद्दिष्ट ग्रामीण भारतातून खुल्या शौचाची प्रथा संपुष्टात आणून प्रत्येक घरात शौचालय उपलब्ध करणे हे आहे.',
      aboutEn:
          'Swachh Bharat Mission (Gramin) is an important campaign of the Government of India. The objective of this campaign is to end the practice of open defecation in rural India and provide a toilet in every household.',
      whoCanApplyMr:
          'ज्या कुटुंबांकडे शौचालय नाही असे सर्व ग्रामीण कुटुंब (BPL व APL दोन्ही)',
      whoCanApplyEn:
          'All rural families (both BPL and APL) who do not have a toilet',
      benefitsMr:
          '• शौचालय बांधणीसाठी ₹१२,००० अनुदान\n• ODF गावांना अतिरिक्त प्रोत्साहन\n• सामुदायिक शौचालय बांधणीसाठी मदत',
      benefitsEn:
          '• ₹12,000 grant for toilet construction\n• Additional incentives for ODF villages\n• Assistance for community toilet construction',
      eligibilityMr:
          '• ग्रामीण भागात राहणारे असणे आवश्यक\n• घरात शौचालय नसणे आवश्यक\n• आधार कार्ड असणे अनिवार्य\n• बँक खाते असणे आवश्यक',
      eligibilityEn:
          '• Must be a resident of rural area\n• Must not have a toilet at home\n• Aadhaar card is mandatory\n• Must have a bank account',
      requiredDocuments: [
        'आधार कार्ड / Aadhaar Card',
        'रेशन कार्ड / Ration Card',
        'बँक पासबुक / Bank Passbook',
        'घर नकाशा / House Map',
        'फोटो / Passport Size Photo',
      ],
      howToApplyMr:
          '१. ग्रामपंचायत कार्यालयात जाऊन अर्ज करा.\n२. ग्रामसेवक घराची पाहणी करतील.\n३. पात्र ठरल्यावर बँक खात्यात रक्कम जमा होईल.\n४. शौचालय बांधून पूर्ण झाल्यावर उर्वरित रक्कम मिळेल.',
      howToApplyEn:
          '1. Apply at the Gram Panchayat office.\n2. Gram Sevak will inspect the house.\n3. After eligibility confirmation, amount will be credited to bank account.\n4. Remaining amount will be received after toilet construction is complete.',
      officialSourceUrl: 'https://sbm.gov.in',
      officialSourceLabel: 'sbm.gov.in',
      lastUpdated: 'जून २०२५ / June 2025',
      informationSource:
          'जलशक्ती मंत्रालय, भारत सरकार / Ministry of Jal Shakti, Govt. of India',
      applyUrl: 'https://sbm.gov.in',
    ),
    const SchemeModel(
      id: 'sch_004',
      nameMr: 'प्रधानमंत्री किसान सन्मान निधी',
      nameEn: 'PM Kisan Samman Nidhi',
      department: 'कृषी मंत्रालय',
      departmentEn: 'Ministry of Agriculture',
      shortDescMr: 'शेतकऱ्यांना वार्षिक ₹६,००० थेट बँक खात्यात',
      shortDescEn:
          'Annual ₹6,000 directly to farmers\' bank accounts in 3 instalments',
      eligibilitySummaryMr:
          'लहान व सीमांत शेतकरी ज्यांच्याकडे २ हेक्टरपर्यंत जमीन आहे',
      eligibilitySummaryEn:
          'Small and marginal farmers with up to 2 hectares of land',
      category: 'agriculture',
      aboutMr:
          'प्रधानमंत्री किसान सन्मान निधी (PM-KISAN) ही केंद्र सरकारची एक महत्त्वाची योजना आहे. या योजनेंतर्गत पात्र शेतकऱ्यांना वार्षिक ₹६,००० रुपये तीन समान हप्त्यांमध्ये थेट बँक खात्यात जमा केले जातात.',
      aboutEn:
          'PM Kisan Samman Nidhi (PM-KISAN) is an important scheme of the Central Government. Under this scheme, eligible farmers receive ₹6,000 annually in three equal instalments directly credited to their bank accounts.',
      whoCanApplyMr:
          'लहान व सीमांत शेतकरी ज्यांच्याकडे २ हेक्टरपर्यंत शेतजमीन आहे',
      whoCanApplyEn:
          'Small and marginal farmers who own up to 2 hectares of agricultural land',
      benefitsMr:
          '• वार्षिक ₹६,००० (तीन हप्त्यांमध्ये ₹२,०००)\n• थेट बँक खात्यात जमा\n• कोणतेही मध्यस्थ नाही',
      benefitsEn:
          '• Annual ₹6,000 (₹2,000 in three instalments)\n• Direct credit to bank account\n• No intermediaries',
      eligibilityMr:
          '• शेतकरी असणे आवश्यक\n• जमीन २ हेक्टरपेक्षा कमी असावी\n• आधार कार्ड असणे अनिवार्य\n• बँक खाते आधारशी जोडलेले असणे आवश्यक\n• सरकारी कर्मचारी पात्र नाहीत',
      eligibilityEn:
          '• Must be a farmer\n• Land should be less than 2 hectares\n• Aadhaar card is mandatory\n• Bank account must be linked to Aadhaar\n• Government employees are not eligible',
      requiredDocuments: [
        'आधार कार्ड / Aadhaar Card',
        '७/१२ उतारा / 7/12 Extract',
        'बँक पासबुक / Bank Passbook',
        'मोबाइल नंबर / Mobile Number',
        'फोटो / Passport Size Photo',
      ],
      howToApplyMr:
          '१. pmkisan.gov.in वर ऑनलाइन नोंदणी करा.\n२. किंवा ग्रामपंचायत / CSC केंद्रात जाऊन नोंदणी करा.\n३. आधार व बँक खाते जोडा.\n४. पात्रता तपासणीनंतर हप्ते मिळण्यास सुरुवात होईल.',
      howToApplyEn:
          '1. Register online at pmkisan.gov.in.\n2. Or visit Gram Panchayat / CSC centre for registration.\n3. Link Aadhaar and bank account.\n4. After eligibility verification, instalments will start.',
      officialSourceUrl: 'https://pmkisan.gov.in',
      officialSourceLabel: 'pmkisan.gov.in',
      lastUpdated: 'ऑगस्ट २०२५ / August 2025',
      informationSource:
          'कृषी मंत्रालय, भारत सरकार / Ministry of Agriculture, Govt. of India',
      applyUrl: 'https://pmkisan.gov.in',
    ),
    const SchemeModel(
      id: 'sch_005',
      nameMr: 'प्रधानमंत्री जन आरोग्य योजना (आयुष्मान भारत)',
      nameEn: 'Ayushman Bharat - PMJAY',
      department: 'आरोग्य मंत्रालय',
      departmentEn: 'Ministry of Health & Family Welfare',
      shortDescMr:
          'दुय्यम व तृतीयक रुग्णालयात वार्षिक ₹५ लाखांपर्यंत मोफत उपचार',
      shortDescEn:
          'Free treatment up to ₹5 lakh per year at secondary and tertiary hospitals',
      eligibilitySummaryMr: 'SECC डेटाबेसमध्ये नाव असलेले गरीब व वंचित कुटुंब',
      eligibilitySummaryEn:
          'Poor and deprived families listed in SECC database',
      category: 'health',
      aboutMr:
          'आयुष्मान भारत - प्रधानमंत्री जन आरोग्य योजना (AB-PMJAY) ही जगातील सर्वात मोठी आरोग्य विमा योजना आहे. या योजनेंतर्गत पात्र कुटुंबांना दुय्यम व तृतीयक रुग्णालयात वार्षिक ₹५ लाखांपर्यंत मोफत उपचार मिळतो.',
      aboutEn:
          'Ayushman Bharat - PM Jan Arogya Yojana (AB-PMJAY) is the world\'s largest health insurance scheme. Under this scheme, eligible families get free treatment up to ₹5 lakh per year at secondary and tertiary hospitals.',
      whoCanApplyMr:
          'SECC (सामाजिक-आर्थिक जात जनगणना) डेटाबेसमध्ये नाव असलेले गरीब व वंचित कुटुंब',
      whoCanApplyEn:
          'Poor and deprived families listed in SECC (Socio-Economic Caste Census) database',
      benefitsMr:
          '• वार्षिक ₹५ लाखांपर्यंत मोफत उपचार\n• १,३५० पेक्षा जास्त आजारांवर उपचार\n• सरकारी व खाजगी रुग्णालयात उपलब्ध\n• कुटुंबाच्या आकारावर मर्यादा नाही',
      benefitsEn:
          '• Free treatment up to ₹5 lakh per year\n• Treatment for more than 1,350 diseases\n• Available at government and private hospitals\n• No restriction on family size',
      eligibilityMr:
          '• SECC डेटाबेसमध्ये नाव असणे आवश्यक\n• आधार कार्ड असणे अनिवार्य\n• आयुष्मान कार्ड असणे आवश्यक',
      eligibilityEn:
          '• Name must be in SECC database\n• Aadhaar card is mandatory\n• Ayushman card is required',
      requiredDocuments: [
        'आधार कार्ड / Aadhaar Card',
        'रेशन कार्ड / Ration Card',
        'मोबाइल नंबर / Mobile Number',
        'फोटो / Passport Size Photo',
      ],
      howToApplyMr:
          '१. pmjay.gov.in वर पात्रता तपासा.\n२. जवळच्या CSC केंद्र किंवा सरकारी रुग्णालयात जा.\n३. आयुष्मान कार्ड बनवा.\n४. कार्ड वापरून पात्र रुग्णालयात मोफत उपचार घ्या.',
      howToApplyEn:
          '1. Check eligibility at pmjay.gov.in.\n2. Visit nearest CSC centre or government hospital.\n3. Get Ayushman Card made.\n4. Use card to get free treatment at empanelled hospitals.',
      officialSourceUrl: 'https://pmjay.gov.in',
      officialSourceLabel: 'pmjay.gov.in',
      lastUpdated: 'जुलै २०२५ / July 2025',
      informationSource:
          'आरोग्य मंत्रालय, भारत सरकार / Ministry of Health, Govt. of India',
      applyUrl: 'https://pmjay.gov.in',
    ),
    const SchemeModel(
      id: 'sch_006',
      nameMr: 'महाराष्ट्र शासन लेक लाडकी योजना',
      nameEn: 'Lek Ladki Yojana (Maharashtra)',
      department: 'महिला व बालविकास विभाग, महाराष्ट्र',
      departmentEn: 'Women & Child Development Dept., Maharashtra',
      shortDescMr: 'मुलींच्या जन्मापासून ते शिक्षणापर्यंत आर्थिक सहाय्य',
      shortDescEn: 'Financial assistance to girls from birth to education',
      eligibilitySummaryMr:
          'महाराष्ट्रातील पिवळ्या व केशरी रेशन कार्डधारक कुटुंबातील मुली',
      eligibilitySummaryEn:
          'Girls from yellow and orange ration card holder families in Maharashtra',
      category: 'women',
      aboutMr:
          'लेक लाडकी योजना ही महाराष्ट्र शासनाची एक महत्त्वाची योजना आहे. या योजनेंतर्गत पिवळ्या व केशरी रेशन कार्डधारक कुटुंबातील मुलींना जन्मापासून ते शिक्षणापर्यंत टप्प्याटप्प्याने आर्थिक सहाय्य दिले जाते.',
      aboutEn:
          'Lek Ladki Yojana is an important scheme of the Maharashtra Government. Under this scheme, girls from yellow and orange ration card holder families receive financial assistance in phases from birth to education.',
      whoCanApplyMr:
          'महाराष्ट्रातील पिवळ्या (BPL) व केशरी रेशन कार्डधारक कुटुंबातील मुली',
      whoCanApplyEn:
          'Girls from yellow (BPL) and orange ration card holder families in Maharashtra',
      benefitsMr:
          '• जन्मावेळी: ₹५,०००\n• इयत्ता १ ली प्रवेशावेळी: ₹४,०००\n• इयत्ता ६ वी प्रवेशावेळी: ₹६,०००\n• इयत्ता ११ वी प्रवेशावेळी: ₹८,०००\n• वयाच्या १८ व्या वर्षी: ₹७५,०००',
      benefitsEn:
          '• At birth: ₹5,000\n• At Class 1 admission: ₹4,000\n• At Class 6 admission: ₹6,000\n• At Class 11 admission: ₹8,000\n• At age 18: ₹75,000',
      eligibilityMr:
          '• महाराष्ट्रातील रहिवासी असणे आवश्यक\n• पिवळे किंवा केशरी रेशन कार्ड असणे आवश्यक\n• मुलगी असणे आवश्यक\n• आधार कार्ड असणे अनिवार्य',
      eligibilityEn:
          '• Must be a resident of Maharashtra\n• Must have yellow or orange ration card\n• Must be a girl child\n• Aadhaar card is mandatory',
      requiredDocuments: [
        'जन्म दाखला / Birth Certificate',
        'आधार कार्ड / Aadhaar Card',
        'रेशन कार्ड / Ration Card',
        'आई-वडिलांचे आधार कार्ड / Parents Aadhaar Card',
        'बँक पासबुक / Bank Passbook',
        'शाळेचा दाखला / School Certificate (for education stages)',
      ],
      howToApplyMr:
          '१. ग्रामपंचायत / आंगणवाडी केंद्रात जाऊन अर्ज करा.\n२. आवश्यक कागदपत्रे सादर करा.\n३. बाल विकास प्रकल्प अधिकाऱ्याकडे अर्ज पाठवला जाईल.\n४. पात्रता तपासणीनंतर लाभ मिळण्यास सुरुवात होईल.',
      howToApplyEn:
          '1. Apply at Gram Panchayat / Anganwadi centre.\n2. Submit required documents.\n3. Application will be forwarded to Child Development Project Officer.\n4. Benefits will start after eligibility verification.',
      officialSourceUrl: 'https://womenchild.maharashtra.gov.in',
      officialSourceLabel: 'womenchild.maharashtra.gov.in',
      lastUpdated: 'मे २०२५ / May 2025',
      informationSource:
          'महिला व बालविकास विभाग, महाराष्ट्र शासन / Women & Child Development Dept., Govt. of Maharashtra',
      applyUrl: 'https://womenchild.maharashtra.gov.in',
    ),
  ];
}
