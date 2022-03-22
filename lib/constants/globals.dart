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

String URL_DEFAULT =
    "https://nbcpalmsprings.com/wp-content/uploads/sites/8/2021/12/BEST-MOVIES-OF-2021.jpeg";

String URL_BASE = 'https://image.tmdb.org/t/p/w500';

String URL_RECIPE =
    "https://dcassetcdn.com/design_img/375573/141837/141837_3015959_375573_image.jpg";

List bookCategory = [
  "art",
  "bibliography",
  "cook",
  "drama",
  "education",
  "fantasy",
  "fiction",
  "historical",
  "horror",
  "religious",
  "travel"
];

List mealTypes = [
  "breakfast",
  "lunch",
  "dinner",
  "snack",
];

List dishTypes = [
  "desserts",
];
