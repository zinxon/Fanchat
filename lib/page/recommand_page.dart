import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_pdf_viewer/flutter_pdf_viewer.dart';
import 'package:youtube_player/youtube_player.dart';

import '../style/theme.dart' as Theme;
import 'youtube_page.dart';

class RecommandPage extends StatefulWidget {
  final String investorType;

  RecommandPage(this.investorType);
  @override
  _RecommandPageState createState() => _RecommandPageState();
}

class _RecommandPageState extends State<RecommandPage> {
  String content;
  String suggestMarket;
  List<LinearSales> data;
  VideoPlayerController _videoController;

  @override
  void initState() {
    getContent(widget.investorType);
    super.initState();
  }

  void getContent(String investorType) {
    if (investorType == "保守型投資者") {
      content = '''
這類人有很強的責任心和事業心，他們堅定、尊重權威，持保守的價值觀，傾向於相信並遵照投資專家的建議。\n
保守型投資者適合投資債券、債券基金等風險較低的投資產品，維持均衡型投資組合，或委託專業的理財顧問。宜適當地向進取型投資者學習其大膽的精神，以發現更多的投資機遇，創造更大的收益。\n
保守型投資者非常注重自己的本金安全，相對於非常冒險的獲取收益，他們更傾向於讓資產穩定、低風險的增長。保守型投資者時刻關注著自己的資產，對出現的損失會表現出焦慮，對短期表現也會比較在意。由於擔心投資決策出現錯誤，他們也會有些選擇困難的症狀。\n
保守型投資者更應該把眼光放長遠些，過分強調和注重短期收益無助於規避風險。相反，基於短期走勢做出的決策更可能在長線上讓投資者虧損。保守型投資者應該關注於一些確定的、低風險投資機會，挖掘價值窪地和風險錯配的標的，並儘可能把雞蛋分散在不同籃子里以防範系統性風險。
''';
      suggestMarket = "債券、債券基金";
      data = [
        new LinearSales("現金", 10),
        new LinearSales("股票", 30),
        new LinearSales("債券", 60),
      ];
    } else if (investorType == "進取型投資者") {
      content = '''這類人具有冒險精神，反應敏捷，擅長處理技巧性強的工作，但是容易衝動，缺乏耐性。\n
進取型投資者適合投資對基金等高風險的產品，或者進行石油、黃金等短線投資。同時也應該向保守型投資者學習，面對重大投資決定時，以客觀實際的資訊作支撐，而非單純地依靠直覺，從而克服一時衝動和不理智。\n
進取型投資者通常缺少主見，對金融市場、宏觀經濟和行業投資研究不多，因此也就難以對形勢作出自己的判斷。他們的決策往往隨波逐流，取決於大潮流的方向和周圍人的選擇，這也就意味著他們的決策往往不夠慎重。\n
進取型投資者很難做到自己分析市場形勢，總是依據分析師、券商研報、甚至小道消息進行投資決策。一旦市場中進取型投資者居多，那麼追漲殺跌就可能造成股市巨大的泡沫。建議進取型投資者多培養自身對行業和公司的判斷，或者直接定投指數基金。
    ''';
      suggestMarket = "期貨期權";
      data = [
        new LinearSales("現金", 5),
        new LinearSales("股票", 70),
        new LinearSales("債券", 25),
      ];
    } else if (investorType == "獨立型投資者") {
      content =
          '''這類人是獨立的、理性的、有能力的人，他們有天生好奇心，喜歡夢想，有獨創性、創造力、洞察力、有興趣獲得新知識，有極強的分析問題、解決問題的能力。\n
獨立型投資者適合投資中國或新興市場等尖端市場，或者能夠發揮他們分析能力優勢的對基金領域。但由於過於自信，也會做出不理智的投資決定，應當向保守型投資者學習，適時地考慮投資專家及他人的明智建議。\n
獨立型投資者通常掌握充足的金融投資知識，而且十分熱衷於金融投資，他們一般具備批判性的思維方式和強大的問題分析能力，擅長獨立作出決策，而且對自己的決策充滿信心。\n
這類投資者同樣有過度自信的缺點，他們太過相信自己的判斷，以至於忽視甚至排斥與自己意見不同但卻十分重要的信息，這就很容易導致決策失誤。
''';
      suggestMarket = "新上市股票、新興市場";
      data = [
        new LinearSales("現金", 10),
        new LinearSales("股票", 50),
        new LinearSales("債券", 40),
      ];
    } else if (investorType == "增長型投資者") {
      content = '''這類人在精神上有極強的哲理性，他們善於言辯、充滿活力、有感染力，他們是理想主義者和精神領袖。\n
增長型投資者適合以月供這種「細水長流」的方式投資。由於情緒易波動，容易被新觀點、新思想和新資訊左右，應當獨立型投資者學習其客觀科學的態度，眼於長期的投資策略和總資產的變動，而非一時的市場波動帶來的資產消長。\n
增長型投資者對自己的投資決策總是充滿自信，他們對市場和行業的分析基本能夠邏輯自洽，他們很肯定自己的投資能力，能堅持自己的選擇。同時敢於冒險，能在著眼全局的前提下大膽地作出具有長遠意義的決策。\n
但這一類型的投資者往往伴隨著一個缺點，就是盲目、過度自信，在投資交易中，他們往往誇大自​​己預測市場的能力，而他們固執己見的決策態度也會干擾他們的理性判斷，這都意味著積累型投資者的投資會伴隨著更大的風險。
''';
      suggestMarket = "月供藍籌股";
      data = [
        new LinearSales("現金", 5),
        new LinearSales("股票", 60),
        new LinearSales("債券", 35),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "推薦投資組合",
          style: Theme.TextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Theme.AppColors.greyColor2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                            title: Text(
                              '${widget.investorType}\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            contentPadding: EdgeInsets.all(5),
                            subtitle: Text(
                              content,
                            )),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text('建議投資市場 : $suggestMarket'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 150,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.orangeAccent,
                  color: Colors.orange,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {
                      PdfViewer.loadAsset(
                        'assets/pdf/test.pdf',
                      );
                    },
                    child: Center(
                      child: Text(
                        '組合分析',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 150,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.orangeAccent,
                  color: Colors.orange,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YoutubePage()),
                      );
                    },
                    child: Center(
                      child: Text(
                        '投資入門影片',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 300,
                child: PieOutsideLabelChart.withSampleData(data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  PieOutsideLabelChart(this.seriesList);

  /// Creates a [PieChart] with sample data and no transition.
  factory PieOutsideLabelChart.withSampleData(List<LinearSales> data) {
    return new PieOutsideLabelChart(
      _createData(data),
      // Disable animations for image tests.
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 60,
          arcRendererDecorators: [new charts.ArcLabelDecorator()],
        ));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, String>> _createData(
      List<LinearSales> data) {
    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.type,
        measureFn: (LinearSales sales, _) => sales.percentage,
        data: data,
        labelAccessorFn: (LinearSales row, _) =>
            '${row.type}: ${row.percentage}%',
      )
    ];
  }
}

class LinearSales {
  final String type;
  final int percentage;

  LinearSales(this.type, this.percentage);
}
