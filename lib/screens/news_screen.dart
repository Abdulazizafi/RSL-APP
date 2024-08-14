import 'package:flutter/material.dart';
import 'package:football_app/constants.dart';
import 'package:football_app/widgets/news_item.dart';

class NewsPage extends StatelessWidget {
  NewsPage({Key? key}) : super(key: key);

  final List<NewsItem> newsItems = [
    NewsItem(
      title: "Jesus: Winning is my habit wherever I've been",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/12/3ad743b2-9c0f-4212-b523-93ac2cb49b20/Jesus-celebrating-Al-Hilal-winning-RSL-title.JPG?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/498300/jesus-winning-is-my-habit-wherever-ive-been",
      publicationDate: '12 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title:
          "Al Hilal beat Al Hazem to seal RSL title, Firmino and Kessie lead Al Ahli comeback",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/12/6af635c8-a044-4059-ab5c-05292e2a9b11/Roberto-Firmino-celebrates-scoring-against-Al-Shabab.JPG?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/498240/al-hilal-beat-al-hazem-to-seal-rsl-title-firmino-and-kessie-lead-al-ahli-comeback",
      publicationDate: '12 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title: "Neymar hails title-winning Al Hilal teammates",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/12/3b170bc8-e8ec-493d-97d8-d5285c6911ed/Neymar-celebrate.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/498238/neymar-hails-title-winning-al-hilal-teammates",
      publicationDate: '12 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title: "Gerrard celebrates emphatic Al Ettifaq victory over Al Ittihad",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/11/a0d785fb-ff8b-45e4-91f1-7417740434d3/Steven-Gerrard-Al-Ittihad-v-Al-Ettifaq.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/498138/gerrard-celebrates-emphatic-al-ettifaq-victory-over-al-ittihad",
      publicationDate: '11 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title: "How Al Hilal won the 2023-24 Roshn Saudi League title",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/11/05fc4b77-9f87-48e8-bdf4-258a1727d6e2/Al-Hilal-celebrate.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/498137/how-al-hilal-won-the-2023-24-rsl-title",
      publicationDate: '11 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title:
          "Ekambi hat-trick downs Al Ittihad, Ighalo on the double for Al Wehda",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/11/e4e651d8-c92d-4b0c-ac76-f62386394938/Karl-Toko-Ekambi-celebrates-scoring-for-Al-Ettifaq-against-Al-Ittihad.JPG?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/498116/ekambi-hat-trick-downs-al-ittihad-ighalo-on-the-double-for-al-wehda",
      publicationDate: '11 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title:
          "Brozovic strikes late to win it for Al Nassr, Al Riyadh hold Al Taawoun",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/02/f0840814-1aa9-4bd3-b285-3f6f103a0db5/Otavio-Al-Nassr-Ighalo-Al-Wehda.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/498106/brozovic-strikes-late-to-win-it-for-al-nassr-al-riyadh-hold-al-taawoun",
      publicationDate: '10 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title: 'PREVIEW: Roshn Saudi League matchweek 31',
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/09/ef1d7fd4-4063-4be5-86d5-dab4eac4fdc3/Riyad-Mahrez-Al-Ahli-Romain-Saiss-Al-Shabab.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/497547/preview-roshn-saudi-league-matchweek-31",
      publicationDate: '09 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title: "Red hot Carrasco proud of Al Shabab's resurgence",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/02/ca34199d-6542-4064-ad0f-efd073b66d6a/Yannick-Carrasco-Al-Shabab-v-Al-Taawoun.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/497411/red-hot-carrasco-proud-of-al-shabab-resurgence",
      publicationDate: '01 May 2024', // Example date
      NameP: "SPL",
    ),
    NewsItem(
      title: "Malcom the hero as Al Hilal take huge step toward RSL title",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/07/3ef87679-0ce1-49a0-bc6a-4456bbe913c6/GettyImages-2151218479.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/497266/malcom-the-hero-as-al-hilal-take-a-huge-step-toward-rsl-title",
      publicationDate: '28 Apr 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title:
          "Al Ahli versus Al Hilal conjures memories of 2015-16 RSL title showdown",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/saudi-pro-league/photo/2023/10/27/f9426713-ae4d-43b6-b385-7f4bd251304c/1749110981.jpg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/497226/al-ahli-al-hilal-conjures-memories-2015-16-title-showdown",
      publicationDate: '06 May 2024',
      NameP: "SPL",
    ),
    NewsItem(
      title: "Saudi Pro League to focus on signing U21 players",
      imageUrl:
          "https://resources.saudi-pro-league.pulselive.com/photo-resources/2024/05/05/5f356d0e-fe3b-4e63-85f3-1fd3618d4c77/Saad-Al-Lazeez.jpeg?width=451&height=254",
      url:
          "https://www.spl.com.sa/en/news/497225/saad-al-lazeez-press-conference",
      publicationDate: '05 May 2024',
      NameP: "SPL",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
            'assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png'), // Add your icon
        title: const Text("News",
            style: TextStyle(
                color: Colors.white)), // Set title text color to white
        backgroundColor:
            kprimaryColor, // Set AppBar background color to kprimaryColor
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final item = newsItems[index];
          return NewsWidget(item: item); // Use the NewsWidget for each item
        },
      ),
    );
  }
}
