class User {
  String id;
  String name;
  String password;
  String birthDate;
  String gender;
  String image = '';
  String hasClinic = '';
  String phone = '';
  String specialist = '';
  String degree = '';
  String qualifications = '';
  String graduationYear = '';

  User({
    this.id,
    this.name,
    this.password,
    this.birthDate,
    this.gender,
    this.image,
    this.hasClinic,
    this.phone,
    this.specialist,
    this.degree,
    this.qualifications,
    this.graduationYear,
  });

  get getId => id;
  get getName => name;
  get getPassword => password;
  get getBirthDate => birthDate;
  get getGender => gender;
  get getImage => image;
  get getHasClinic => hasClinic;
  get getPhone => phone;
  get getSpecialist => specialist;
  get getQualifications => qualifications;
  get getDegree => degree;
  get getGraduationYear => graduationYear;

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'password': this.password,
      'birthDate': this.birthDate,
      'gender': this.gender,
      'image': this.image,
      'hasClinic': this.hasClinic,
      'phone': this.phone,
      'specialist': this.specialist,
      'qualifications': this.qualifications,
      'degree': this.degree,
      'graduationYear': this.graduationYear,
    };
  }

  factory User.fromMap(Map map) {
    return User(
      name: map['name'],
      password: map['password'],
      gender: map['gender'],
      birthDate: map['birthDate'],
      image: map['image'],
      id: map['id'],
      hasClinic: map['hasClinic'],
      phone: map['phone'],
      specialist: map['specialist'],
      qualifications: map['qualifications'],
      degree: map['degree'],
      graduationYear: map['graduationYear'],
    );
  }
}
