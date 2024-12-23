import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/widgets/audio_wave.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var _selectedColor = Pallete.cardColor;
  File? _selectedImage;
  File? _selectedAudio;

  void _selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        _selectedAudio = pickedAudio;
      });
    }
  }

  void _selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _songNameController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeViewModelProvider.select((value) => value?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Song Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () async {
              if (formKey.currentState!.validate() && _selectedAudio != null && _selectedImage != null) {
                await ref.read(homeViewModelProvider.notifier).uploadSong(
                      selectedAudio: _selectedAudio!,
                      selectedThumbnail: _selectedImage!,
                      songName: _songNameController.text,
                      artist: _artistController.text,
                      selectedColor: _selectedColor,
                      token: ref.read(currentUserNotifierProvider)!.token,
                    );
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _selectImage,
                        child: _selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                radius: Radius.circular(10),
                                color: Pallete.borderColor,
                                borderType: BorderType.RRect,
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.square,
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(height: 10),
                                      Text('Select the thumbnail for your song'),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                      _selectedAudio != null
                          ? AudioWave(path: _selectedAudio!.path)
                          : CustomField(
                              hintText: 'Pick Song',
                              controller: null,
                              readOnly: true,
                              onTap: _selectAudio,
                            ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: 'Artist',
                        controller: _artistController,
                      ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: 'Song Name',
                        controller: _songNameController,
                      ),
                      ColorPicker(
                        pickersEnabled: {
                          ColorPickerType.wheel: true,
                        },
                        color: _selectedColor,
                        onColorChanged: (value) {
                          setState(() {
                            _selectedColor = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
