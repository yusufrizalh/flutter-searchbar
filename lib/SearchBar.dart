// ignore_for_file: file_names, missing_return, prefer_is_not_empty, avoid_print, prefer_const_constructors, unnecessary_this, use_key_in_widget_constructors, deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final dio = Dio();
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List names = List();
  List filteredNames = List();
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('Search name');

  _SearchBarState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  _buildBar(BuildContext context) {
    return AppBar(
      title: _appBarTitle,
      centerTitle: true,
      leading: IconButton(onPressed: _searchPressed, icon: _searchIcon),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(filteredNames[index]['name']),
          onTap: () => print(filteredNames[index]['name']),
        );
      },
    );
  }

  void _getNames() async {
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/users');
    print(response.data);
    List tempList = List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(response.data[i]);
    }
    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search...',
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = Text('Search example...');
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}
