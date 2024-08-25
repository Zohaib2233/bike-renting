import 'package:bike_gps/core/constants/app_colors.dart';


import 'package:bike_gps/core/constants/app_images.dart';


import 'package:bike_gps/view/widget/my_text_widget.dart';


import 'package:dropdown_button2/dropdown_button2.dart';


import 'package:flutter/material.dart';


// ignore: must_be_immutable


class CustomDropDown extends StatelessWidget {

  CustomDropDown({

    required this.heading,

    required this.hint,

    required this.items,

    this.selectedValue,

    required this.onChanged,

    this.bgColor,

    this.marginBottom = 12,

    this.haveHeading = true,

    this.width,

    this.headingWeight,

    this.isSelected = false,

  });


  final List<dynamic>? items;


  String? selectedValue;


  final ValueChanged<dynamic>? onChanged;


  String heading, hint;


  Color? bgColor;


  double? marginBottom, width;


  bool? haveHeading, isSelected;


  FontWeight? headingWeight;


  @override

  Widget build(BuildContext context) {

    return Padding(

      padding: EdgeInsets.only(bottom: marginBottom!),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [

          if (haveHeading!)

            MyText(

              text: heading,

              size: 12,

              color: kDarkGreyColor,

              paddingBottom: 3,

              weight: headingWeight ?? FontWeight.w500,

            ),

          DropdownButtonHideUnderline(

            child: DropdownButton2(

              items: items!

                  .map(

                    (item) => DropdownMenuItem<dynamic>(

                      value: item,

                      child: Row(

                        children: [

                          MyText(

                            text: item,

                            size: 12,

                            color: kTertiaryColor,

                            weight: FontWeight.w500,

                          ),

                        ],

                      ),

                    ),

                  )

                  .toList(),

              value: selectedValue,

              onChanged: onChanged,

              iconStyleData: IconStyleData(

                icon: Image.asset(

                  Assets.imagesArrowRightIosBlack,

                  height: 14,

                ),

              ),

              isDense: true,

              isExpanded: false,

              customButton: Container(

                height: 48,

                padding: EdgeInsets.symmetric(

                  horizontal: 15,

                ),

                decoration: BoxDecoration(

                  color: kPrimaryColor,

                  borderRadius: BorderRadius.circular(50),

                  border: Border.all(

                    color: kInputBorderColor,

                    width: 1.0,

                  ),

                  boxShadow: [

                    BoxShadow(

                      color: kBlackColor.withOpacity(0.03),

                      blurRadius: 47,

                      offset: Offset(-2, 6),

                    ),

                  ],

                ),

                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    MyText(

                      text: selectedValue! == hint ? hint : selectedValue!,


                      size: 12,


                      // color: selectedValue == hint


                      //     ? kTertiaryColor.withOpacity(0.4)


                      //     : kTertiaryColor,

                      color: isSelected == true
                          ? kBlackColor
                          : kTertiaryColor.withOpacity(0.4),

                    ),

                    Image.asset(

                      Assets.imagesArrowRightIosBlack,

                      height: 14,

                    ),

                  ],

                ),

              ),

              menuItemStyleData: MenuItemStyleData(

                height: 48,

              ),

              dropdownStyleData: DropdownStyleData(

                elevation: 3,

                maxHeight: 300,

                offset: Offset(0, -5),

                decoration: BoxDecoration(

                  border: Border.all(

                    color: kTertiaryColor.withOpacity(0.06),

                    width: 1.0,

                  ),

                  borderRadius: BorderRadius.circular(16),

                  color: kPrimaryColor,

                ),

              ),

            ),

          ),

        ],

      ),

    );

  }

}


// ignore: must_be_immutable


class SimpleDropDown extends StatelessWidget {

  SimpleDropDown({

    required this.items,

    this.selectedValue,

    required this.onChanged,

    this.width,

    this.header,

  });


  final List<dynamic>? items;


  String? selectedValue;


  final ValueChanged<dynamic>? onChanged;


  double? width;


  final Widget? header;


  @override

  Widget build(BuildContext context) {

    return Theme(

      data: Theme.of(context).copyWith(

        splashColor: Colors.transparent,

        highlightColor: Colors.transparent,

      ),

      child: DropdownButtonHideUnderline(

        child: DropdownButton2(

          items: List.generate(

            items!.length,

            (index) {

              return DropdownMenuItem<dynamic>(

                value: items![index],

                child: Row(

                  children: [

                    Expanded(

                      child: MyText(

                        text: items![index],

                        size: 12,

                        weight: FontWeight.w600,

                        color: kTertiaryColor,

                      ),

                    ),

                    if (selectedValue == items![index])

                      Icon(

                        Icons.check,

                        color: kSecondaryColor,

                        size: 18,

                      ),

                  ],

                ),

              );

            },

          ),

          value: selectedValue,

          onChanged: onChanged,

          isDense: true,

          isExpanded: false,

          customButton: header,

          menuItemStyleData: MenuItemStyleData(

            height: 38,

          ),

          dropdownStyleData: DropdownStyleData(

            elevation: 3,

            width: width,

            maxHeight: 300,

            offset: Offset(0, -5),

            decoration: BoxDecoration(

              border: Border.all(

                color: kTertiaryColor.withOpacity(0.06),

                width: 1.0,

              ),

              borderRadius: BorderRadius.circular(16),

              color: kPrimaryColor,

            ),

          ),

        ),

      ),

    );

  }

}

