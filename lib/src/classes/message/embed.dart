class Embed {
  String? title;
  String? description;
  String type = "rich";
  String? url;
  String? timestamp;
  String? color;
  String? footer;
  String? image;
  String? thumbnail;
  String? author;
  String? fields;

  Embed({ 
    this.title, 
    this.description, 
    this.url, 
    this.timestamp, 
    this.color, 
    this.footer, 
    this.image, 
    this.thumbnail, 
    this.author, 
    this.fields 
  });

  Map<String, dynamic> exportable() {
    Map<String, dynamic> a = {};
    if (title != null) {
      a["title"] = title;
    }
    if (description != null) {
      a["description"] = description;
    }
    if (url != null) {
      a["url"] = url;
    }
    if (timestamp != null) {
      a["timestamp"] = timestamp;
    }
    if (color != null) {
      a["color"] = color;
    }
    if (footer != null) {
      a["footer"] = footer;
    }
    if (image != null) {
      a["image"] = image;
    }
    if (thumbnail != null) {
      a["thumbnail"] = thumbnail;
    }
    if (author != null) {
      a["author"] = author;
    }
    if (fields != null) {
      a["fields"] = fields;
    }
    return a;
  }
}