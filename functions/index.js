const functions = require('firebase-functions');
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'your-email@gmail.com',
    pass: 'your-email-password',
  },
});

exports.sendEmailOnStatusChange = functions.firestore
  .document('users/{userId}')
  .onUpdate((change, context) => {
    const beforeStatus = change.before.data().status;
    const afterStatus = change.after.data().status;

    if (beforeStatus !== afterStatus) {
      const agencyData = change.after.data();
      const agencyEmail = agencyData.email;
      const subject = `Your agency status has been updated`;
      const text = `Dear ${agencyData.name},\n\nYour agency status is now: ${afterStatus}\n\nRegards,\nAdmin`;

      return transporter.sendMail({
        from: 'your-email@gmail.com',
        to: agencyEmail,
        subject: subject,
        text: text,
      });
    }
    return null;
  });
