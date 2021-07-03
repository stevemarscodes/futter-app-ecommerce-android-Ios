import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/store_profile.dart';
import 'package:australti_ecommerce_app/models/store.dart';

import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:australti_ecommerce_app/widgets/modal_bottom_sheet.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';

class CategorySelectStore extends StatefulWidget {
  @override
  _CategorySelectStoreState createState() => _CategorySelectStoreState();
}

class _CategorySelectStoreState extends State<CategorySelectStore> {
  final storeProfileBloc = StoreProfileBloc();

  final categoryCtrl = TextEditingController();
  bool loading = false;
  Store store;
  @override
  void initState() {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    store = authService.storeAuth;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (store.user.first) openSheetBottom();
    });
    super.initState();
  }

  @override
  void dispose() {
    storeProfileBloc.dispose();
    super.dispose();
  }

  void openSheetBottom() {
    showSelectServiceMaterialCupertinoBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    final authService = Provider.of<AuthenticationBLoC>(context);

    if (authService.serviceSelect == 1) categoryCtrl.text = 'Restaurante';

    if (authService.serviceSelect == 2)
      categoryCtrl.text = 'Frutería/Verdulería';
    if (authService.serviceSelect == 3)
      categoryCtrl.text = 'Licorería/Botillería';

    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              color: currentTheme.accentColor,
              icon: Icon(
                Icons.chevron_left,
                size: 40,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              (!loading)
                  ? IconButton(
                      color: (authService.serviceSelect != store.service)
                          ? currentTheme.accentColor
                          : Colors.grey,
                      icon: Icon(
                        Icons.check,
                        size: 35,
                      ),
                      onPressed: () {
                        if (authService.serviceSelect != store.service)
                          _editProfile();
                      })
                  : buildLoadingWidget(context),
            ],
          ),
          backgroundColor: Colors.black,
          body: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(new FocusNode()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width,
                      child: Text(
                        '¿En qué categoria te calificarías?',
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Container(
                      width: size.width,
                      child: Text(
                        'Las categorias ayudan a las personas a encontrarte.',
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // email

                    _createCategory(),

                    // password

                    // submit
                  ],
                )),
          )),
    ));
  }

  Widget _createCategory() {
    return StreamBuilder(
      stream: storeProfileBloc.categoryStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: categoryCtrl,
            showCursor: true,
            readOnly: true,
            onTap: () {
              showSelectServiceMaterialCupertinoBottomSheet(context);
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Categoría',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeCategory,
          ),
        );
      },
    );
  }

  _editProfile() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final storeProfile = store;

    setState(() {
      loading = true;
    });

    final editProfileOk = await authService.editServiceStoreProfile(
        storeProfile.user.uid, authService.serviceSelect);

    if (editProfileOk != null) {
      if (editProfileOk == true) {
        setState(() {
          loading = false;
        });

        showSnackBar(context, 'Categoria guardada');

        (store.user.first || store.service == 0)
            ? Navigator.push(context, contactoInfoStoreRoute())
            : Navigator.pop(context);
      } else {
        showAlertError(context, 'Error', '');
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
  }
}
