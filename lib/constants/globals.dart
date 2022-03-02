// login text field data
import 'package:ne_yapsam_ki/models/mongoDBModel.dart';
import 'package:ne_yapsam_ki/models/movie_model.dart';

late String inputEmail;
late String inputPassword;

// SignUp text field data
late String inputFullName;
late String inputAge;
late String inputSex;
// String inputEmailSignUp;
// String inputPasswordSignUp;
late String inputConfirmPassword;

// Sorted List
List<String> selectedGenres = ["movie"];
List<MongoDbMovieModel> sortedMovies = [];
