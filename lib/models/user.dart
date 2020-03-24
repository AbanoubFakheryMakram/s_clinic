
class User {
  String id;
  String name;
  String password;
  String birthDate;
  String gender;
  String image = '';
  String hasClinic = '';
  String address = '';
  String fee = '';
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
    this.address,
    this.fee,
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
  get getAddress => address;
  get getFee => fee;
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
      'address': this.address,
      'fee': this.fee,
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
      address: map['address'],
      fee: map['fee'],
      phone: map['phone'],
      specialist: map['specialist'],
      qualifications: map['qualifications'],
      degree: map['degree'],
      graduationYear: map['graduationYear'],
    );
  }
}
