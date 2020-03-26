class Case {
  String doctor_id;
  String doctor_image;
  String doctor_name;
  String doctor_gender;
  String doctor_spec;
  String date;
  String post_id;
  String patient_height;
  String patient_weight;
  String patient_gender;
  String patient_bmi;
  String diagnosis; //التشخيص
  List<String> symptoms; //  الاعراض
  List<String> pharmaceutical; // الادوية
  List<String> likes;
  List<String> comments;

  Case({
    this.doctor_id,
    this.doctor_image,
    this.doctor_name,
    this.doctor_gender,
    this.doctor_spec,
    this.date,
    this.post_id,
    this.patient_height,
    this.patient_weight,
    this.patient_gender,
    this.patient_bmi,
    this.diagnosis,
    this.symptoms,
    this.pharmaceutical,
    this.likes,
    this.comments,
  });

  Map<String, dynamic> postsToMap() {
    return {
      'doctor_id': this.doctor_id,
      'doctor_name': this.doctor_name,
      'doctor_image': this.doctor_image,
      'doctor_gender': this.doctor_gender,
      'doctor_spec': this.doctor_spec,
      'patient_height': this.patient_height,
      'patient_weight': this.patient_weight,
      'patient_gender': this.patient_gender,
      'patient_bmi': this.patient_bmi,
      'date': this.date,
      'post_id': this.post_id,
      'diagnosis': this.diagnosis,
      'symptoms': this.symptoms,
      'pharmaceutical': this.pharmaceutical,
      'likes': this.likes,
      'comments': this.comments,
    };
  }

  factory Case.fromDoc(Map<String, dynamic> doc) {
    return Case(
      comments: List.from(doc['comments']),
      likes: List.from(doc['likes']),
      symptoms: List.from(doc['symptoms']),
      pharmaceutical: List.from(doc['pharmaceutical']),
      doctor_name: doc['doctor_name'],
      doctor_gender: doc['doctor_gender'],
      doctor_image: doc['doctor_images'],
      doctor_id: doc['doctor_id'],
      doctor_spec: doc['doctor_spec'],
      date: doc['date'],
      post_id: doc['post_id'],
      patient_gender: doc['patient_gender'],
      patient_weight: doc['patient_weight'],
      patient_bmi: doc['patient_bmi'],
      patient_height: doc['patient_height'],
      diagnosis: doc['diagnosis'],
    );
  }
}
