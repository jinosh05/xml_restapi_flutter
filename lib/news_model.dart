// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  final Rss rss;

  NewsModel({
    required this.rss,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        rss: Rss.fromJson(json["rss"]),
      );

  Map<String, dynamic> toJson() => {
        "rss": rss.toJson(),
      };
}

class Rss {
  final String version;
  final List<Xmln> xmlns;
  final String xmlnsDc;
  final String xmlnsAtom;
  final Channel channel;

  Rss({
    required this.version,
    required this.xmlns,
    required this.xmlnsDc,
    required this.xmlnsAtom,
    required this.channel,
  });

  factory Rss.fromJson(Map<String, dynamic> json) => Rss(
        version: json["version"],
        xmlns: List<Xmln>.from(json["xmlns"].map((x) => Xmln.fromJson(x))),
        xmlnsDc: json["xmlns\u0024dc"],
        xmlnsAtom: json["xmlns\u0024atom"],
        channel: Channel.fromJson(json["channel"]),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "xmlns": List<dynamic>.from(xmlns.map((x) => x.toJson())),
        "xmlns\u0024dc": xmlnsDc,
        "xmlns\u0024atom": xmlnsAtom,
        "channel": channel.toJson(),
      };
}

class Channel {
  final List<AtomLink> atomLink;
  final Copyright title;
  final Copyright link;
  final Copyright description;
  final Copyright language;
  final Copyright copyright;
  final Copyright docs;
  final ImageModel image;
  final List<NewsItem> item;

  Channel({
    required this.atomLink,
    required this.title,
    required this.link,
    required this.description,
    required this.language,
    required this.copyright,
    required this.docs,
    required this.image,
    required this.item,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        atomLink: List<AtomLink>.from(
            json["atom\u0024link"].map((x) => AtomLink.fromJson(x))),
        title: Copyright.fromJson(json["title"]),
        link: Copyright.fromJson(json["link"]),
        description: Copyright.fromJson(json["description"]),
        language: Copyright.fromJson(json["language"]),
        copyright: Copyright.fromJson(json["copyright"]),
        docs: Copyright.fromJson(json["docs"]),
        image: ImageModel.fromJson(json["image"]),
        item:
            List<NewsItem>.from(json["item"].map((x) => NewsItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "atom\u0024link": List<dynamic>.from(atomLink.map((x) => x.toJson())),
        "title": title.toJson(),
        "link": link.toJson(),
        "description": description.toJson(),
        "language": language.toJson(),
        "copyright": copyright.toJson(),
        "docs": docs.toJson(),
        "image": image.toJson(),
        "item": List<dynamic>.from(item.map((x) => x.toJson())),
      };
}

class AtomLink {
  final String type;
  final String? rel;
  final String href;

  AtomLink({
    required this.type,
    this.rel,
    required this.href,
  });

  factory AtomLink.fromJson(Map<String, dynamic> json) => AtomLink(
        type: json["type"],
        rel: json["rel"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "rel": rel,
        "href": href,
      };
}

class Copyright {
  final String t;

  Copyright({
    required this.t,
  });

  factory Copyright.fromJson(Map<String, dynamic> json) => Copyright(
        t: json["\u0024t"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024t": t,
      };
}

class ImageModel {
  final Copyright title;
  final Copyright link;
  final Copyright url;

  ImageModel({
    required this.title,
    required this.link,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        title: Copyright.fromJson(json["title"]),
        link: Copyright.fromJson(json["link"]),
        url: Copyright.fromJson(json["url"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "link": link.toJson(),
        "url": url.toJson(),
      };
}

class NewsItem {
  final Copyright title;
  final Description description;
  final Copyright link;
  final Copyright guid;
  final Copyright pubDate;
  final Copyright dcCreator;
  final Enclosure enclosure;

  NewsItem({
    required this.title,
    required this.description,
    required this.link,
    required this.guid,
    required this.pubDate,
    required this.dcCreator,
    required this.enclosure,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        title: Copyright.fromJson(json["title"]),
        description: Description.fromJson(json["description"]),
        link: Copyright.fromJson(json["link"]),
        guid: Copyright.fromJson(json["guid"]),
        pubDate: Copyright.fromJson(json["pubDate"]),
        dcCreator: Copyright.fromJson(json["dc\u0024creator"]),
        enclosure: Enclosure.fromJson(json["enclosure"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "description": description.toJson(),
        "link": link.toJson(),
        "guid": guid.toJson(),
        "pubDate": pubDate.toJson(),
        "dc\u0024creator": dcCreator.toJson(),
        "enclosure": enclosure.toJson(),
      };
}

class Description {
  final String cdata;

  Description({
    required this.cdata,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        cdata: json["__cdata"],
      );

  Map<String, dynamic> toJson() => {
        "__cdata": cdata,
      };
}

class Enclosure {
  final Type type;
  final String length;
  final String url;

  Enclosure({
    required this.type,
    required this.length,
    required this.url,
  });

  factory Enclosure.fromJson(Map<String, dynamic> json) => Enclosure(
        type: typeValues.map[json["type"]]!,
        length: json["length"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "length": length,
        "url": url,
      };
}

enum Type { IMAGE_JPEG }

final typeValues = EnumValues({"image/jpeg": Type.IMAGE_JPEG});

class Xmln {
  Xmln();

  factory Xmln.fromJson(Map<String, dynamic> json) => Xmln();

  Map<String, dynamic> toJson() => {};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
