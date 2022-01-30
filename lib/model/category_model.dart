class Category {
  final String name;
  List<String> specs;

  Category(this.name, this.specs);
  
  Future<void> createCategory(Category category) async {}
  Future<void> removeCategory(String categoryName) async {
    // remove category
    // remove category from all specs
  }
  Future<void> addSpec(String specId, String categoryName) async {}
}