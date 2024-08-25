import 'package:bike_gps/controllers/places/places_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/app_styling.dart';
import 'package:bike_gps/core/utils/google_maps/flutter_google_maps_utils.dart';
import 'package:bike_gps/models/google_maps/place_model.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/nearby_bottom_sheet_handle_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class NearbyBottomSheet extends StatefulWidget {
  NearbyBottomSheet({
    super.key,
  });

  @override
  State<NearbyBottomSheet> createState() => _NearbyBottomSheetState();
}

class _NearbyBottomSheetState extends State<NearbyBottomSheet> {
  //finding PlacesController
  PlacesController placesController = Get.find<PlacesController>();

  @override
  void initState() {
    super.initState();
    //getting nearby places of user
    placesController.callNearbyPlacesAPI();
  }

  // final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 55,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        color: kPrimaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NearbyBottomSheetHandle(
              // controller: controller,
              ),
          Container(
            height: 1,
            color: Color(0xff9799A0).withOpacity(0.47),
            width: Get.width,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    // Expanded(flex: 5, child: _CustomSearchField()),
                    Expanded(
                      flex: 4,
                      child: Obx(() => CustomDropDown(
                          hint: placesController
                                  .selectedNearbyPlaceCategory.value.isEmpty
                              ? "Search by category"
                              : placesController
                                  .selectedNearbyPlaceCategory.value,
                          onChanged: (val) {
                            placesController.setNearbyPlaceCategory = val;
                          })),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: _SendButton(onTap: () {
                          //getting nearby places according to selected nearby place category
                          placesController.getNearbyPlaces(
                            category: placesController
                                .selectedNearbyPlaceCategory.value,
                          );
                        })),
                  ],
                ),
                // CustomDropDown(
                //   hint: 'Search',
                //   items: [
                //     'Search',
                //     'Restaurants',
                //     'Hair dresser',
                //     'Tattoo studio',
                //     'Gym',
                //     'Bowling',
                //   ],
                //   selectedValue: 'Search',
                //   onChanged: (v) {},
                // ),
                MyText(
                  paddingTop: 27,
                  text: 'Popular Places',
                  size: 14,
                  weight: FontWeight.w600,
                  paddingBottom: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: 6,
                      width: 22,
                      decoration: AppStyling.INDICATOR,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemCount: placesController.nearbyPlaces.length,
                      itemBuilder: (context, index) {
                        //getting PlaceModel
                        PlaceModel placeModel =
                            placesController.nearbyPlaces[index];

                        return PlaceCard(
                          image: placeModel.photo!,
                          name: placeModel.name!,
                          occupation: placeModel.type!,
                          timeRequired: FlutterGoogleMapsUtils.instance
                              .calculateTravelTime(
                                LatLng(
                                  placesController.userLocation!.latitude,
                                  placesController.userLocation!.longitude,
                                ),
                                placeModel.latLng!,
                              )
                              .inMinutes
                              .toString(),
                          distance: FlutterGoogleMapsUtils.instance
                              .calculateDistance(
                                  LatLng(
                                    placesController.userLocation!.latitude,
                                    placesController.userLocation!.longitude,
                                  ),
                                  placeModel.latLng!)
                              .toStringAsFixed(2),
                          onMore: () {},
                          onViewMap: () {
                            FlutterGoogleMapsUtils.instance.openGoogleMap(
                              sourceLatLng: LatLng(
                                placesController.userLocation!.latitude,
                                placesController.userLocation!.longitude,
                              ),
                              destLatLng: placeModel.latLng!,
                            );
                          },
                        );
                      },
                    )),
                // MyText(
                //   paddingTop: 12,
                //   text: 'Recent Searches',
                //   size: 14,
                //   weight: FontWeight.w600,
                //   paddingBottom: 10,
                // ),
                // Row(
                //   children: [
                //     Container(
                //       height: 6,
                //       width: 22,
                //       decoration: AppStyling.INDICATOR,
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // FutureBuilder<List<RecentPlaceSearchModel>>(
                //     future: placesController.getRecentPlaceSearches(),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.done) {
                //         //if we got an error
                //         if (snapshot.hasError) {
                //           // showSnackbar(title: 'Error', msg: 'Try again');
                //         }
                //         //if we got the data
                //         else if (snapshot.hasData) {
                //           //getting snapshot data
                //           List<RecentPlaceSearchModel> recentSearches =
                //               snapshot.data!;
                //           return GridView.builder(
                //             gridDelegate:
                //                 SliverGridDelegateWithFixedCrossAxisCount(
                //               crossAxisCount: 3,
                //               mainAxisExtent: 32,
                //               crossAxisSpacing: 10,
                //               mainAxisSpacing: 20,
                //             ),
                //             itemCount: recentSearches.length,
                //             shrinkWrap: true,
                //             padding: EdgeInsets.zero,
                //             physics: BouncingScrollPhysics(),
                //             itemBuilder: (context, index) {
                //               //getting RecentPlaceSearchModel
                //               RecentPlaceSearchModel recentPlaceSearchModel =
                //                   recentSearches[index];
                //               return Row(
                //                 children: [
                //                   CommonImageView(
                //                     height: 32,
                //                     width: 32,
                //                     radius: 100.0,
                //                     // imagePath: _searches[index]['icon'],
                //                     url: recentPlaceSearchModel.photoUrl,
                //                   ),
                //                   Expanded(
                //                     child: MyText(
                //                       paddingLeft: 10,
                //                       lineHeight: 1.5,
                //                       text: recentPlaceSearchModel.name!,
                //                       size: 10,
                //                       weight: FontWeight.w600,
                //                     ),
                //                   ),
                //                 ],
                //               );
                //             },
                //           );
                //         }
                //       }
                //       return Center(
                //           child: const CupertinoActivityIndicator(
                //         animating: true,
                //         radius: 20,
                //         color: kSecondaryColor,
                //       ));
                //     }),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildSearchBar(OutlineInputBorder _inputBorder) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: kBlackColor,
            ),
            decoration: InputDecoration(
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.imagesSearch,
                    height: 24,
                    color: kSecondaryColor,
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              hintStyle: TextStyle(
                fontSize: 12,
                color: kBlackColor,
              ),
              hintText: 'in Forchheim',
              border: _inputBorder,
              enabledBorder: _inputBorder,
              focusedBorder: _inputBorder,
              focusedErrorBorder: _inputBorder,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kSecondaryColor,
          ),
          child: Icon(
            Icons.play_arrow,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.hint,
    required this.onChanged,
  });

  final ValueChanged<dynamic>? onChanged;
  String hint;

  final List<Map<String, String>> _categories = [
    {
      'icon': Assets.imagesRestaurant,
      'title': 'Restaurant',
    },
    {
      'icon': Assets.imagesTatto,
      'title': 'Tattoo Studio',
    },
    {
      'icon': Assets.imagesGym,
      'title': 'Gym',
    },
    {
      'icon': Assets.imagesBowling,
      'title': 'Bowling',
    },
    {
      'icon': Assets.imagesHairDresser,
      'title': 'Hair Dresser',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            items: List.generate(
              _categories.length,
              (index) {
                return DropdownMenuItem<dynamic>(
                  value: _categories[index]['title'],
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: kGreyColor3.withOpacity(0.32),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        CommonImageView(
                          height: 28,
                          width: 28,
                          radius: 100.0,
                          imagePath: _categories[index]['icon'],
                        ),
                        Expanded(
                          child: MyText(
                            paddingLeft: 12,
                            text: _categories[index]['title']!,
                            size: 12,
                            weight: FontWeight.w500,
                            color: kGreyColor2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // value: selectedValue,
            onChanged: onChanged,
            isDense: true,
            isExpanded: false,
            customButton: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1.0,
                        color: kSecondaryColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.imagesSearch,
                          height: 24,
                          color: kSecondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MyText(
                          text: hint,
                          size: 15,
                          fontFamily: AppFonts.NUNITO_SANS,
                          color: kBlackColor,
                        ),
                        // Expanded(
                        //   child: Row(
                        //     children: [
                        //       RichText(
                        //         text: TextSpan(
                        //           style: TextStyle(
                        //             fontSize: 15,
                        //             fontFamily: AppFonts.NUNITO_SANS,
                        //             color: kBlackColor,
                        //           ),
                        //           children: [
                        //             TextSpan(
                        //               text: 'in ',
                        //             ),
                        //             TextSpan(
                        //               // text: selectedValue == hint
                        //               //     ? hint
                        //               //     : selectedValue!,
                        //               text: hint,
                        //               style: TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 10,
                // ),
                // Container(
                //   height: 48,
                //   width: 48,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8),
                //     color: kSecondaryColor,
                //   ),
                //   child: Icon(
                //     Icons.play_arrow,
                //     color: kPrimaryColor,
                //   ),
                // ),
              ],
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 50,
              padding: EdgeInsets.zero,
            ),
            dropdownStyleData: DropdownStyleData(
              elevation: 3,
              maxHeight: 400,
              offset: Offset(0, -5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.image,
    required this.name,
    required this.occupation,
    required this.distance,
    required this.timeRequired,
    required this.onViewMap,
    required this.onMore,
  });

  final String image, name, occupation, distance, timeRequired;
  final VoidCallback onViewMap;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.0,
          color: kSecondaryColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CommonImageView(
                height: 48,
                width: 48,
                radius: 100.0,
                url: image,
              ),
              Positioned(
                bottom: 0,
                right: 2,
                child: Image.asset(
                  Assets.imagesOnline,
                  height: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: name,
                        size: 16,
                        weight: FontWeight.w700,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: onMore,
                    //   child: Image.asset(
                    //     Assets.imagesMoreHoriz,
                    //     height: 4,
                    //   ),
                    // ),
                  ],
                ),
                MyText(
                  paddingTop: 4,
                  text: occupation,
                  size: 14,
                  color: kGreyColor,
                  paddingBottom: 10,
                  weight: FontWeight.w500,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: '$distance km   .   $timeRequired mins',
                      size: 10,
                      color: kGreyColor,
                    ),
                    MyText(
                      onTap: onViewMap,
                      text: 'View on Map',
                      size: 10,
                      weight: FontWeight.bold,
                      color: kSecondaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//send button widget
class _SendButton extends StatelessWidget {
  const _SendButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kSecondaryColor,
        ),
        child: Icon(
          Icons.play_arrow,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

//custom search field
class _CustomSearchField extends StatelessWidget {
  const _CustomSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesSearch,
              height: 24,
            ),
          ],
        ),
        hintText: 'Search nearby places',
        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: kPrimaryColor,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: kSecondaryColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: kSecondaryColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }
}
