import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//封装ChangeNotifierProvider为一个Widget组件
class BaseView<T extends ChangeNotifier> extends StatefulWidget{

  final Widget Function(BuildContext context,T model,Widget child) builder;

  final T model;

  final Widget child;

  //初始化方法
  final Function(T) onReady;

  //销毁方法
  final Function(T) onDispose;

  BaseView({Key key,this.builder, this.model, this.child, this.onReady,this.onDispose}):super(key:key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}
class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>>{

  T model;
  @override
  void initState() {
    model = widget.model;
    if(widget.onReady!=null){
      widget.onReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(create: (BuildContext context)=>model,child:
      Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      )
      ,lazy: false,);
  }

  @override
  void dispose() {
    model = widget.model;
    if(widget.onDispose!=null){
      widget.onDispose(model);
    }
    super.dispose();
  }


}