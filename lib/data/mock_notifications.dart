import '../models/notification_model.dart';

class MockNotifications {
  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_001',
      title: 'तक्रार स्थिती अपडेट',
      titleEn: 'Complaint Status Updated',
      message:
          'तुमची तक्रार #CMP-2025-001 (पाणी पुरवठा) आता "प्रगतीपथावर" आहे.',
      messageEn:
          'Your complaint #CMP-2025-001 (Water Supply) is now "In Progress".',
      dateTime: DateTime.now().subtract(const Duration(minutes: 15)),
      category: NotificationCategory.complaintUpdate,
      isRead: false,
      referenceId: 'CMP-2025-001',
    ),
    NotificationModel(
      id: 'notif_002',
      title: 'आपत्कालीन सूचना',
      titleEn: 'Emergency Alert',
      message:
          'कृष्णा नदीच्या पाणी पातळीत वाढ. नदीकाठच्या नागरिकांनी सतर्क राहावे.',
      messageEn:
          'Krishna river water level rising. Riverside citizens stay alert.',
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      category: NotificationCategory.emergency,
      isRead: false,
      referenceId: 'notice_001',
    ),
    NotificationModel(
      id: 'notif_003',
      title: 'पेमेंट यशस्वी',
      titleEn: 'Payment Successful',
      message: 'घरपट्टी ₹850 यशस्वीरित्या भरली. पावती क्र. PAY-2025-0892.',
      messageEn: 'House tax ₹850 paid successfully. Receipt No. PAY-2025-0892.',
      dateTime: DateTime.now().subtract(const Duration(hours: 3)),
      category: NotificationCategory.payment,
      isRead: false,
      referenceId: 'PAY-2025-0892',
    ),
    NotificationModel(
      id: 'notif_004',
      title: 'नवीन योजना उपलब्ध',
      titleEn: 'New Scheme Available',
      message:
          'PM आवास योजना अंतर्गत अर्ज सुरू झाले आहेत. अंतिम तारीख: ३१ ऑगस्ट.',
      messageEn:
          'Applications open under PM Awas Yojana. Last date: 31 August.',
      dateTime: DateTime.now().subtract(const Duration(hours: 5)),
      category: NotificationCategory.scheme,
      isRead: true,
      referenceId: 'scheme_001',
    ),
    NotificationModel(
      id: 'notif_005',
      title: 'सेवा अर्ज मंजूर',
      titleEn: 'Service Application Approved',
      message: 'तुमचा Bonafide प्रमाणपत्र अर्ज #SRV-2025-045 मंजूर झाला आहे.',
      messageEn:
          'Your Bonafide Certificate application #SRV-2025-045 is approved.',
      dateTime: DateTime.now().subtract(const Duration(hours: 8)),
      category: NotificationCategory.serviceUpdate,
      isRead: true,
      referenceId: 'SRV-2025-045',
    ),
    NotificationModel(
      id: 'notif_006',
      title: 'ग्रामसभा बैठक',
      titleEn: 'Gram Sabha Meeting',
      message: 'दि. २५ ऑगस्ट रोजी सकाळी १० वाजता ग्रामसभा बैठक आयोजित आहे.',
      messageEn: 'Gram Sabha meeting scheduled on 25 Aug at 10:00 AM.',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      category: NotificationCategory.panchayatNotice,
      isRead: true,
      referenceId: 'notice_003',
    ),
    NotificationModel(
      id: 'notif_007',
      title: 'तक्रार निराकरण',
      titleEn: 'Complaint Resolved',
      message:
          'तुमची तक्रार #CMP-2025-002 (रस्ता दुरुस्ती) यशस्वीरित्या निराकरण झाली.',
      messageEn:
          'Your complaint #CMP-2025-002 (Road Repair) has been resolved.',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      category: NotificationCategory.complaintUpdate,
      isRead: true,
      referenceId: 'CMP-2025-002',
    ),
    NotificationModel(
      id: 'notif_008',
      title: 'मालमत्ता कर थकबाकी',
      titleEn: 'Property Tax Due',
      message: 'मालमत्ता कर भरण्याची अंतिम तारीख ३१ ऑगस्ट. थकबाकी: ₹1,250.',
      messageEn: 'Property tax due date is 31 August. Outstanding: ₹1,250.',
      dateTime: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      category: NotificationCategory.payment,
      isRead: false,
      referenceId: 'notice_002',
    ),
    NotificationModel(
      id: 'notif_009',
      title: 'MGNREGA नोंदणी सुरू',
      titleEn: 'MGNREGA Registration Open',
      message: 'MGNREGA अंतर्गत रोजगार नोंदणी सुरू झाली आहे. आजच अर्ज करा.',
      messageEn: 'MGNREGA employment registration is now open. Apply today.',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      category: NotificationCategory.scheme,
      isRead: true,
      referenceId: 'scheme_002',
    ),
    NotificationModel(
      id: 'notif_010',
      title: 'सेवा अर्ज प्राप्त',
      titleEn: 'Service Application Received',
      message: '8A उतारा अर्ज #SRV-2025-046 प्राप्त झाला. प्रक्रिया सुरू आहे.',
      messageEn:
          '8A extract application #SRV-2025-046 received. Processing started.',
      dateTime: DateTime.now().subtract(const Duration(days: 4)),
      category: NotificationCategory.serviceUpdate,
      isRead: true,
      referenceId: 'SRV-2025-046',
    ),
  ];
}
