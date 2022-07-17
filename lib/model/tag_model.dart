class Tag {
  final String name;
  List<String> specs;

  Tag(this.name, this.specs);

  Future<void> createTag(Tag tag) async {}
  Future<void> removeTag(String tagName) async {
    // remove tag
    // remove tag from all specs
  }
  Future<void> addSpec(String specName, String tagName) async {}
}
