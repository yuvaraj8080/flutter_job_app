import 'package:flutter/material.dart';

import '../../utils/shimmer_circular_Indicator/shimmer.dart';

class TCategoryShimmer extends StatelessWidget{
  const TCategoryShimmer({
    super.key,
    this.itemCount = 6,
});

  final int itemCount;

  @override
  Widget build(BuildContext context){
    return SizedBox(height:80,
    child:ListView.separated(
      shrinkWrap:true,
        scrollDirection:Axis.horizontal,
        itemBuilder:(_,__){
        return const Column(
          crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              ///Image
              TShimmerEffect(width: 55, height:55,radius: 55),
              SizedBox(width:8),

              /// text
              TShimmerEffect(width:55, height:8),
        ]);
        }, separatorBuilder:(_,__)=> const SizedBox(width:10), itemCount: itemCount)
    );
  }
}