// login text field data
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
List<Movie> sortedMovies = [
  Movie(
    title: 'Avengers: Endgame',
    genre: 'Action, Adventure, Fantasy',
    year: '2019',
    imageUrl:
        'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg',
    imdb: '8.4',
    description:
        "After the devastating events of Avengers: Infinity War (2018), the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos' actions and restore balance to the universe.",
  )
];
