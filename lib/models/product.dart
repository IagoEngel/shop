class Product{
  final String id;
  final String title;
  final String description;
  final double value;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.value,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void toogleFavourite(){
    isFavourite = !isFavourite;
  }

}