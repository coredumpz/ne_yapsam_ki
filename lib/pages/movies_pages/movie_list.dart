import '../../models/movie_model.dart';

class MovieList {
  static List<Movie> getMovies() {
    return [
      Movie(
        title: 'Avengers: Endgame',
        genre: 'Action, Adventure, Fantasy',
        year: '2019',
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg',
        imdb: '8.4',
        description:
            "After the devastating events of Avengers: Infinity War (2018), the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos' actions and restore balance to the universe.",
      ),
      Movie(
        title: 'Don\'t Look Up',
        genre: 'Comedy, Drama, Sci-Fi',
        year: '2021',
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BNjZjNDE1NTYtYTgwZS00M2VmLWEyODktM2FlNjhiYTk3OGU2XkEyXkFqcGdeQXVyMTEyMjM2NDc2._V1_.jpg',
        imdb: '7.3',
        description:
            "Two low-level astronomers must go on a giant media tour to warn mankind of an approaching comet that will destroy planet Earth.",
      ),
      Movie(
        title: 'No Time to Die',
        genre: 'Action, Adventure, Thriller',
        year: '2021',
        imageUrl:
            'https://m.media-amazon.com/images/I/61Ve0ykiOyL._AC_SY679_.jpg',
        imdb: '7.4',
        description:
            "James Bond has left active service. His peace is short-lived when Felix Leiter, an old friend from the CIA, turns up asking for help, leading Bond onto the trail of a mysterious villain armed with dangerous new technology.",
      ),
      Movie(
        title: 'Parasite',
        genre: 'Comedy, Drama, Thriller',
        year: '2019',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/tr/0/0d/Parazit_2019.jpg',
        imdb: '8.6',
        description:
            "Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.",
      ),
      Movie(
        title: 'Instant Family',
        genre: 'Comedy, Drama',
        year: '2018',
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BMTkzMzgzMTc1OF5BMl5BanBnXkFtZTgwNjQ4MzE0NjM@._V1_.jpg',
        imdb: '7.3',
        description:
            "A couple find themselves in over their heads when they foster three children.",
      ),
      Movie(
        title: 'Joker',
        genre: 'Crime, Drama, Thriller',
        year: '2019',
        imageUrl:
            'https://tr.web.img4.acsta.net/pictures/19/09/11/16/43/1511539.jpg',
        imdb: '8.4',
        description:
            "In Gotham City, mentally troubled comedian Arthur Fleck is disregarded and mistreated by society. He then embarks on a downward spiral of revolution and bloody crime. This path brings him face-to-face with his alter-ego: the Joker.",
      ),
      Movie(
        title: 'Fight Club',
        genre: 'Action, Thriller',
        year: '1999',
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BMmEzNTkxYjQtZTc0MC00YTVjLTg5ZTEtZWMwOWVlYzY0NWIwXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_FMjpg_UX1000_.jpg',
        imdb: '8.8',
        description:
            "An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.",
      ),
      Movie(
        title: 'Django Unchained',
        genre: 'Drama, Western',
        year: '2012',
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BMjIyNTQ5NjQ1OV5BMl5BanBnXkFtZTcwODg1MDU4OA@@._V1_.jpg',
        imdb: '8.4',
        description:
            "With the help of a German bounty-hunter, a freed slave sets out to rescue his wife from a brutal plantation-owner in Mississippi.",
      ),
      Movie(
        title: 'Tenet',
        genre: 'Action, Sci-Fi, Thriller',
        year: '2020',
        imageUrl:
            'https://i0.wp.com/dialmformovie.net/wp-content/uploads/2020/08/TENET-Kapak.jpg?fit=793%2C937&ssl=1',
        imdb: '7.4',
        description:
            "Armed with only one word, Tenet, and fighting for the survival of the entire world, a Protagonist journeys through a twilight world of international espionage on a mission that will unfold in something beyond real time.",
      ),
      Movie(
        title: 'The Dark Knight',
        genre: 'Action, Crime, Drama',
        year: '2008',
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_FMjpg_UX1000_.jpg',
        imdb: '9.0',
        description:
            "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
      ),
    ];
  }
}
