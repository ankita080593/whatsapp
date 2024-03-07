// enum statusenum {
//   text('text'),
//   image('image'),
//   audio('audio'),
//   video('video'),
//   gif('gif');
//
//   const statusenum(this.type);
//   final String type;
// }
//
// //
// extension ConverMessage on String {
//   statusenum toEnum() {
//     switch (this) {
//       case 'audio':
//         return statusenum.audio;
//       case 'image':
//         return statusenum.image;
//       case 'text':
//         return statusenum.text;
//       case 'gif':
//         return statusenum.gif;
//       case 'video':
//         return statusenum.video;
//       default:
//         return statusenum.text;
//     }
//   }
// }