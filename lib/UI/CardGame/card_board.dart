import 'dart:math';

import 'package:doodler/Bloc/dataBloc.dart';
import 'package:doodler/Bloc/dataEvent.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import './card_item.dart';

class CardBoard extends StatefulWidget {
  final Function()? onWin;

  const CardBoard({Key? key, this.onWin}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CardBoardState();
  }
}

class CardBoardState extends State<CardBoard> {
  late DataBloc dataBloc;
  List<int> openedCards = [];
  late List<CardModel> cards;

  @override
  void didChangeDependencies() {
    dataBloc = BlocProvider.of<DataBloc>(context);
    dataBloc.mapEventToState(FetchCardData());
    super.didChangeDependencies();
  }

  @override
  void initState() {
    //
    super.initState();
    //cards = createCards();
    cards = categoryList() as List<CardModel>;
    //print(cards);
  }

  Future<List<CardModel>> categoryList() async {
    Stream<List<CardModel>> _currentEntries =
        dataBloc.cardStream as Stream<List<CardModel>>;

    return await _currentEntries.first;
  }

  List<CardModel> createCards() {
    List<String> asset = [];
    // List(5).forEach((f) => NetworkImage(url));
    [5].forEach((f) => asset.add('0${(asset.length + 1)}.jpg'));
    [(5)].forEach((f) => asset.add('0${(asset.length - 5 + 1)}.jpg'));
    return [10].map((f) {
      int index = Random().nextInt(1000) % asset.length;
      String _image =
          'asset/' + asset[index].substring(asset[index].length - 6);

      print("Image:" + _image);
      print("asset:" + asset[index]);
      asset.removeAt(index);
      return CardModel(
          id: 10 - asset.length - 1, image: _image, key: UniqueKey());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: 4,
        childAspectRatio: 322 / 433,
        children: cards
            .map((f) => CardItem(
                key: f.key,
                model: f,
                onFlipCard: handleFlipCard as dynamic Function(bool, int?)?))
            .toList());
  }

  void handleFlipCard(bool isOpened, int id) {
    cards[id].isNeedCloseEffect = false;

    checkOpenedCard(isOpened);

    if (isOpened) {
      setCardOpened(id);
      openedCards.add(id);
    } else {
      setCardNone(id);
      openedCards.remove(id);
    }

    checkWin();
  }

  void checkOpenedCard(bool isOpened) {
    if (openedCards.length == 2 && isOpened) {
      cards[openedCards[0]].isNeedCloseEffect = true;
      setCardNone(openedCards[0]);
      cards[openedCards[1]].isNeedCloseEffect = true;
      setCardNone(openedCards[1]);
      openedCards.clear();
    }
  }

  void checkWin() {
    if (openedCards.length == 2) {
      if (cards[openedCards[0]].image == cards[openedCards[1]].image) {
        setCardWin(openedCards[0]);
        setCardWin(openedCards[1]);
        openedCards.clear();
        widget.onWin!();
      }
    }
  }

  void setCardNone(int id) {
    setState(() {
      cards[id].status = ECardStatus.None;
      cards[id].key = UniqueKey();
    });
  }

  void setCardOpened(int id) {
    setState(() {
      cards[id].status = ECardStatus.Opened;
      cards[id].key = UniqueKey();
    });
  }

  void setCardWin(int id) {
    setState(() {
      cards[id].status = ECardStatus.Win;
      cards[id].key = UniqueKey();
    });
  }
}
