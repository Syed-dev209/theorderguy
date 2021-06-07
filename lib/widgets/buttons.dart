import 'package:flutter/material.dart';

import '../Constant.dart';

class button extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlinebtn;
  final bool isloading;
  button({this.text,this.onPressed,this.outlinebtn,this.isloading});
  @override

  Widget build(BuildContext context) {
    bool _outlinebtn = outlinebtn ?? false;
    ///formloading state
    bool _isloading = isloading ?? false;


    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color:_outlinebtn ? Colors.transparent : Colors.white ,
          border: Border.all(color: Colors.white,width: 1.4),
          borderRadius: BorderRadius.circular(7.0),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10.0,
        ),
        child:   Stack(
          children: [
            Visibility(
              visible:  _isloading ? false :true,
              child: Center(
                child: Text(
                  text ??  "Text ",
                  style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: _outlinebtn ? Colors.white:Colors.black ),
                ),
              ),
            ),
            Visibility(
              visible: _isloading,
              child: Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
