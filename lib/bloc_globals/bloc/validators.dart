import 'dart:async';

class Validators {
  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Correo electrónico invalido');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Contraseña debe ser mayor a 6 caracteres');
    }
  });

  final validationNameRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 5) {
      sink.add(text);
    } else {
      sink.addError('Nombre debe ser mayor a 5 caracteres');
    }
  });

  final validationNumberPhoneRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 9) {
      sink.add(text);
    } else {
      sink.addError('Número de telefono invalido');
    }
  });

  final validationRutRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 9) {
      sink.add(text);
    } else {
      sink.addError('Rut invalido');
    }
  });

  final validationNumberBank =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 9) {
      sink.add(text);
    } else {
      sink.addError('Número de cuenta de invalido');
    }
  });

  final validationAddressRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 15) {
      sink.add(text);
    } else {
      sink.addError('Ingresa Dirección (Calle y numero)');
    }
  });

  final validationWattsRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Watts is required');
    }
  });

  final validationKelvinRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Kelvin is required');
    }
  });
  final validationQuantityRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Quantity is required');
    }
  });

  final validationGradosCRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Grados celsius es requerido');
    }
  });

  final validationWideRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Wide is required');
    }
  });

  final validationLongRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Long is required');
    }
  });

  final validationTallRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Tall is required');
    }
  });

  final validationTimeOnRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Hora de encendido is required');
    }
  });

  final validationTimeOffRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Hora de apagado is required');
    }
  });

  final validationUserNameRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Username is required');
    }
  });
}

final validationOk =
    StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
  if (text.length > 1) {
    sink.add(text);
  } else {
    // sink.addError('Ingrese requerido');
  }
});
