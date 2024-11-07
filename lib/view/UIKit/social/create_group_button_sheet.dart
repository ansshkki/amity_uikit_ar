import 'package:amity_uikit_beta_service/viewmodel/create_group_request_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/configuration_viewmodel.dart';

class CreateGroupButtonSheet extends StatefulWidget {
  const CreateGroupButtonSheet({super.key});

  @override
  State<CreateGroupButtonSheet> createState() => _CreateGroupButtonSheetState();
}

class _CreateGroupButtonSheetState extends State<CreateGroupButtonSheet> {
  final globalKey = GlobalKey<FormState>();

  final groupName = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateGroupRequestVM>(
      create: (context) => CreateGroupRequestVM(),
      child: Consumer<CreateGroupRequestVM>(
        builder: (context, vm, widget) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: globalKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text("group.create_request".tr()),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: groupName,
                      decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "group.name".tr(),
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "group.empty_error".tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                    "external.details".tr(),
                      style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: description,
                    minLines: 2,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "external.details".tr(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "group.details_empty".tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  vm.status == Statevm.loading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Provider.of<AmityUIConfiguration>(context)
                                    .appColors
                                    .primary,
                              ),
                            ),
                            onPressed: () async {
                              if (globalKey.currentState?.validate() ?? false) {
                                await Provider.of<CreateGroupRequestVM>(
                                  context,
                                  listen: false,
                                )
                                    .createGroupRequest(
                                  groupName.text,
                                  description.text,
                                )
                                    .then((val) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("external.required_done".tr()),
                                  ));
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                "external.required".tr(),
                                style: TextStyle(
                                  color:
                                      Provider.of<AmityUIConfiguration>(context)
                                          .appColors
                                          .baseBackground,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom),
                    const SizedBox(height: 12),
                    vm.status == Statevm.error
                        ? Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              vm.errorMessage ?? "repo.unknown_error".tr(),
                              style: TextStyle(
                                  color:
                                      Provider.of<AmityUIConfiguration>(context)
                                          .appColors
                                          .alert,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
