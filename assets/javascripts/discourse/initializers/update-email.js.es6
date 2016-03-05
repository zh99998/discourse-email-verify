import NotActivated from 'discourse/controllers/not-activated';

export default {
  name: 'update_email',

  initialize: function() {
    NotActivated.reopen({
      actions: {
        sendActivationEmail: function() {
          Discourse.ajax('/users/action/send_activation_email', {data: {username: this.get('username')}, type: 'POST'});
          this.set('emailSent', true);
        },
        updateEmail: function() {
          let email = prompt('新的电子邮箱地址', this.get('currentEmail'));
          if (!email) { return };
          this.set('currentEmail', email);
          Discourse.ajax('/users/action/send_activation_email', {data: {username: this.get('username'), email: email}, type: 'POST'});
          this.set('emailSent', true);
        }
      }
    });
  }

};

