import '../models/faq_model.dart';

/// Static FAQ database — Phase 1 (controlled Q&A).
/// In Phase 2, replace [FaqService.findAnswer] with an LLM/RAG API call.
class FaqData {
  static const List<FaqAnswer> answers = [
    FaqAnswer(
      id: 'faq_01',
      question: 'ग्रामपंचायत म्हणजे काय?',
      questionEn: 'What is a Gram Panchayat?',
      answer:
          'ग्रामपंचायत ही गावाच्या स्थानिक प्रशासनाची संस्था आहे. ती नागरिकांना विविध नागरी सेवा, प्रमाणपत्रे, कर व इतर सुविधा उपलब्ध करून देते.',
      source: 'Smart Panchayat माहिती केंद्र',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_02',
      question: 'सरपंच कोण आहेत?',
      questionEn: 'Who is the Sarpanch?',
      answer:
          'आपल्या ग्रामपंचायतीचे विद्यमान सरपंच यांची माहिती येथे पाहता येईल. कृपया आपल्या ग्रामपंचायतीची अधिकृत माहिती तपासा.',
      source: 'ग्रामपंचायत अधिकृत नोंदी',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_03',
      question: 'ग्रामसेवक कोण आहेत?',
      questionEn: 'Who is the GramSevak?',
      answer:
          'ग्रामसेवक हे ग्रामपंचायतीच्या प्रशासकीय कामकाजात महत्त्वाची भूमिका बजावतात. आपल्या ग्रामपंचायतीच्या संपर्क विभागात त्यांची माहिती उपलब्ध आहे.',
      source: 'ग्रामपंचायत संपर्क विभाग',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_04',
      question: 'ग्रामपंचायत कार्यालय कुठे आहे?',
      questionEn: 'Where is the Panchayat office?',
      answer:
          'आपल्या ग्रामपंचायत कार्यालयाचा पत्ता, वेळ आणि संपर्क क्रमांक Smart Panchayat मधील महत्त्वाचे संपर्क विभागात पाहता येईल.',
      source: 'Smart Panchayat — महत्त्वाचे संपर्क',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_05',
      question: 'ग्रामपंचायत कार्यालयाची वेळ काय आहे?',
      questionEn: 'What are the office timings?',
      answer:
          'ग्रामपंचायत कार्यालयाची नियमित वेळ आपल्या ग्रामपंचायतीनुसार बदलू शकते. कृपया अधिकृत कार्यालयीन वेळ तपासा.',
      source: 'ग्रामपंचायत कार्यालय',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_06',
      question: 'ग्रामसभा कधी होते?',
      questionEn: 'When is the Gram Sabha held?',
      answer:
          'ग्रामसभेची तारीख आणि वेळ ग्रामपंचायतीकडून जाहीर केली जाते. नवीन सूचना Smart Panchayat च्या Notices विभागात पाहता येतील.',
      source: 'Smart Panchayat — Notices',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_07',
      question: 'घरपट्टी म्हणजे काय?',
      questionEn: 'What is House Tax?',
      answer:
          'ग्रामपंचायतीच्या हद्दीतील घर किंवा मालमत्तेवर आकारला जाणारा स्थानिक कर म्हणजे घरपट्टी. आपल्या मालमत्तेची थकबाकी Smart Panchayat मध्ये पाहता येऊ शकते.',
      source: 'Smart Panchayat — Payments',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_08',
      question: 'पाणीपट्टी म्हणजे काय?',
      questionEn: 'What is Water Tax?',
      answer:
          'ग्रामपंचायतीकडून दिल्या जाणाऱ्या पाणीपुरवठा सेवेसाठी आकारला जाणारा शुल्क म्हणजे पाणीपट्टी. उपलब्ध असल्यास आपण थकबाकी आणि पेमेंट माहिती येथे पाहू शकता.',
      source: 'Smart Panchayat — Payments',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_09',
      question: 'घरपट्टी ऑनलाइन कशी भरायची?',
      questionEn: 'How can I pay House Tax online?',
      answer:
          'Payments → House Tax येथे जा, आपली मालमत्ता निवडा, देय रक्कम तपासा आणि उपलब्ध ऑनलाइन पेमेंट पर्यायाचा वापर करा.',
      source: 'Smart Panchayat — Payments',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_10',
      question: '8A उतारा म्हणजे काय?',
      questionEn: 'What is an 8A extract?',
      answer:
          '8A उतारा हा जमिनीशी संबंधित महत्त्वाचा महसूल दस्तऐवज आहे. उपलब्ध सेवेनुसार आपण त्यासाठी ऑनलाइन अर्ज करू शकता किंवा दस्तऐवज डाउनलोड करू शकता.',
      source: 'Smart Panchayat — Services',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_11',
      question: '8A उताऱ्यासाठी ऑनलाइन अर्ज कसा करायचा?',
      questionEn: 'How do I apply for 8A?',
      answer:
          'Services → 8A उतारा निवडा, आवश्यक माहिती भरा, आवश्यक कागदपत्रे अपलोड करा, शुल्क असल्यास भरा आणि अर्ज सबमिट करा.',
      source: 'Smart Panchayat — Services',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_12',
      question: 'Bonafide प्रमाणपत्रासाठी अर्ज कसा करायचा?',
      questionEn: 'How do I apply for a Bonafide certificate?',
      answer:
          'Services → Bonafide Certificate निवडा. अर्जातील आवश्यक माहिती भरा, कागदपत्रे अपलोड करा आणि अर्ज सबमिट करा.',
      source: 'Smart Panchayat — Services',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_13',
      question: 'माझ्या अर्जाची स्थिती कशी तपासायची?',
      questionEn: 'How can I track my application?',
      answer:
          'My Applications मध्ये जाऊन आपला अर्ज निवडा. तेथे अर्जाची सद्यस्थिती, शेवटचा अपडेट आणि ग्रामपंचायतीच्या कर्मचाऱ्याची नोंद पाहता येईल.',
      source: 'Smart Panchayat — My Applications',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_14',
      question: 'माझा अर्ज किती दिवसांत पूर्ण होईल?',
      questionEn: 'How long will my application take?',
      answer:
          'सेवेनुसार प्रक्रिया कालावधी वेगवेगळा असतो. अर्जाच्या तपशीलामध्ये अपेक्षित प्रक्रिया कालावधी उपलब्ध असल्यास तो दाखवला जाईल.',
      source: 'Smart Panchayat — Services',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_15',
      question: 'माझी तक्रार ऑनलाइन कशी नोंदवायची?',
      questionEn: 'How do I submit a complaint?',
      answer:
          'Complaints → New Complaint निवडा, समस्येचा प्रकार आणि माहिती भरा. आवश्यक असल्यास फोटो अपलोड करा आणि तक्रार सबमिट करा.',
      source: 'Smart Panchayat — Complaints',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_16',
      question: 'पाणीपुरवठ्याची समस्या असल्यास काय करावे?',
      questionEn: 'What should I do about a water supply problem?',
      answer:
          'Smart Panchayat मधील Complaints → Water Supply निवडा आणि समस्येची माहिती द्या. तक्रार क्रमांकाद्वारे पुढील स्थिती पाहता येईल.',
      source: 'Smart Panchayat — Complaints',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_17',
      question: 'ग्रामपंचायतीच्या नवीन सूचना कुठे पाहता येतील?',
      questionEn: 'Where can I see Panchayat notices?',
      answer:
          'Notices विभागात ग्रामसभा, पाणीपुरवठा, सार्वजनिक सूचना आणि इतर ग्रामपंचायत घोषणा पाहता येतील.',
      source: 'Smart Panchayat — Notices',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_18',
      question: 'ऑनलाइन पेमेंट केल्यानंतर पावती कुठे मिळेल?',
      questionEn: 'Where can I find my payment receipt?',
      answer:
          'पेमेंट यशस्वी झाल्यानंतर पावती My Payments / Payment History मध्ये उपलब्ध होईल, जर त्या सेवेसाठी डिजिटल पावती उपलब्ध असेल.',
      source: 'Smart Panchayat — Payments',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_19',
      question: 'माझा अर्ज नाकारला तर काय करावे?',
      questionEn: 'What if my application is rejected?',
      answer:
          'My Applications मध्ये नकाराचे कारण किंवा कर्मचारी टिप्पणी तपासा. आवश्यक दुरुस्ती करून पुन्हा अर्ज करण्याची सुविधा उपलब्ध असल्यास त्याचा वापर करा किंवा ग्रामपंचायत कार्यालयाशी संपर्क साधा.',
      source: 'Smart Panchayat — My Applications',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
    FaqAnswer(
      id: 'faq_20',
      question: 'ग्रामपंचायतीशी संपर्क कसा साधायचा?',
      questionEn: 'How can I contact the Gram Panchayat?',
      answer:
          'Smart Panchayat मधील Important Contacts विभागात ग्रामपंचायत कार्यालय, सरपंच, ग्रामसेवक आणि उपलब्ध इतर अधिकृत संपर्कांची माहिती पाहता येईल.',
      source: 'Smart Panchayat — Important Contacts',
      lastUpdated: 'ऑगस्ट २०२५',
    ),
  ];

  /// Phase 1: keyword-based FAQ lookup.
  /// Phase 2: Replace this method body with an LLM/RAG API call.
  /// The return type [FaqAnswer?] remains the same — null means no answer found.
  static FaqAnswer? findAnswer(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return null;

    // Score each FAQ by keyword overlap
    FaqAnswer? best;
    int bestScore = 0;

    for (final faq in answers) {
      int score = 0;
      final combined = '${faq.question} ${faq.questionEn}'.toLowerCase();

      // Exact match bonus
      if (combined.contains(q)) score += 10;

      // Word-level matching
      final words = q.split(RegExp(r'\s+'));
      for (final word in words) {
        if (word.length > 2 && combined.contains(word)) score += 2;
      }

      // Keyword shortcuts
      if ((q.contains('complaint') || q.contains('तक्रार')) &&
          combined.contains('तक्रार')) {
        score += 5;
      }
      if ((q.contains('water') || q.contains('पाणी')) &&
          combined.contains('पाणी')) {
        score += 5;
      }
      if ((q.contains('document') ||
              q.contains('कागदपत्र') ||
              q.contains('documents')) &&
          (combined.contains('कागदपत्र') ||
              combined.contains('bonafide') ||
              combined.contains('8a'))) {
        score += 5;
      }
      if ((q.contains('scheme') || q.contains('योजना')) &&
          combined.contains('योजना')) {
        score += 5;
      }
      if ((q.contains('register') || q.contains('नोंदव')) &&
          combined.contains('नोंदव')) {
        score += 5;
      }
      if ((q.contains('pay') || q.contains('भर')) && combined.contains('भर')) {
        score += 3;
      }
      if ((q.contains('track') || q.contains('स्थिती')) &&
          combined.contains('स्थिती')) {
        score += 5;
      }
      if ((q.contains('office') || q.contains('कार्यालय')) &&
          combined.contains('कार्यालय')) {
        score += 5;
      }
      if ((q.contains('contact') || q.contains('संपर्क')) &&
          combined.contains('संपर्क')) {
        score += 5;
      }
      if ((q.contains('notice') || q.contains('सूचना')) &&
          combined.contains('सूचना')) {
        score += 5;
      }
      if ((q.contains('gram sabha') || q.contains('ग्रामसभा')) &&
          combined.contains('ग्रामसभा')) {
        score += 5;
      }
      if ((q.contains('sarpanch') || q.contains('सरपंच')) &&
          combined.contains('सरपंच')) {
        score += 5;
      }
      if ((q.contains('gramsevak') || q.contains('ग्रामसेवक')) &&
          combined.contains('ग्रामसेवक')) {
        score += 5;
      }
      if ((q.contains('house tax') || q.contains('घरपट्टी')) &&
          combined.contains('घरपट्टी')) {
        score += 5;
      }
      if ((q.contains('receipt') || q.contains('पावती')) &&
          combined.contains('पावती')) {
        score += 5;
      }
      if ((q.contains('reject') || q.contains('नाकार')) &&
          combined.contains('नाकार')) {
        score += 5;
      }
      if ((q.contains('8a') || q.contains('उतारा')) &&
          combined.contains('उतारा')) {
        score += 5;
      }

      if (score > bestScore) {
        bestScore = score;
        best = faq;
      }
    }

    return bestScore >= 2 ? best : null;
  }
}
