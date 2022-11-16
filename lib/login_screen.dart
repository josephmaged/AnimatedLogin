import 'package:animation_login/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String testEmail = "jmaged2012@gmail.com";
  String testPassword = "123456";
  final passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Artboard? riveArtBoard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  late RiveAnimationController controllerLookIdle;

  void removeAllControllers() {
    riveArtBoard?.artboard.removeController(controllerIdle);
    riveArtBoard?.artboard.removeController(controllerHandsUp);
    riveArtBoard?.artboard.removeController(controllerHandsDown);
    riveArtBoard?.artboard.removeController(controllerSuccess);
    riveArtBoard?.artboard.removeController(controllerFail);
    riveArtBoard?.artboard.removeController(controllerLookDownRight);
    riveArtBoard?.artboard.removeController(controllerLookDownLeft);
    riveArtBoard?.artboard.removeController(controllerLookIdle);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerIdle);
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsUp);
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsDown);
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerSuccess);
  }

  void addFailController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerFail);
  }

  void addLookDownRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtBoard?.artboard.addController(controllerLookDownRight);
  }

  void addLookDownLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtBoard?.artboard.addController(controllerLookDownLeft);
  }

  void addLookIdleController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerLookIdle);
  }

  void checkForPasswordFocusNodeToChangeAnimation() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else {
        addHandsDownController();
      }
    });
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
        Fluttertoast.showToast(
          msg: 'Login Successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.greenAccent
        );
      } else {
        addFailController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookIdle = SimpleAnimation(AnimationEnum.look_Idle.name);

    rootBundle.load('assets/bear.riv').then(
      (data) {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;

        artboard.addController(controllerIdle);

        setState(() {
          riveArtBoard = artboard;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/Background.png',
                color: Colors.white.withOpacity(0.2),
                colorBlendMode: BlendMode.modulate,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: IntrinsicHeight(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          riveArtBoard == null
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height / 6,
                                  child: Rive(
                                    artboard: riveArtBoard!,
                                  ),
                                ),
                          const SizedBox(height: 25),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  validator: (value) => value != testEmail ? "Wrong email" : null,
                                  onChanged: (value) {
                                    if (value.isNotEmpty && value.length < 18 && !isLookingLeft) {
                                      addLookDownLeftController();
                                    } else if (value.isNotEmpty && value.length > 18 && !isLookingRight) {
                                      addLookDownRightController();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Enter Email',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                  focusNode: passwordFocusNode,
                                  obscureText: true,
                                  onTap: () {
                                    checkForPasswordFocusNodeToChangeAnimation();
                                  },
                                  validator: (value) => value != testPassword ? "Wrong password" : null,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Password',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            clipBehavior: Clip.antiAlias,
                            child: ElevatedButton(
                              onPressed: () {
                                validateEmailAndPassword();
                                passwordFocusNode.unfocus();
                              },
                              child: const Text('Login'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
