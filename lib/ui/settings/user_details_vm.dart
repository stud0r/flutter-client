import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/data/models/company_model.dart';
import 'package:invoiceninja_flutter/redux/settings/settings_actions.dart';
import 'package:invoiceninja_flutter/ui/settings/user_details.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key key}) : super(key: key);
  static const String route = '/$kSettings/$kSettingsUserDetails';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserDetailsVM>(
      converter: UserDetailsVM.fromStore,
      builder: (context, viewModel) {
        return UserDetails(
            key: ValueKey(viewModel.state.settingsUIState.updatedAt),
            viewModel: viewModel);
      },
    );
  }
}

class UserDetailsVM {
  UserDetailsVM({
    @required this.user,
    @required this.state,
    @required this.onChanged,
    @required this.onSavePressed,
    @required this.onCancelPressed,
  });

  static UserDetailsVM fromStore(Store<AppState> store) {
    final state = store.state;

    return UserDetailsVM(
        state: state,
        user: state.uiState.settingsUIState.userCompany.user,
        onChanged: (user) => store.dispatch(UpdateUser(user: user)),
        onCancelPressed: (context) => store.dispatch(ResetSettings()),
        onSavePressed: (context) {
          final completer = snackBarCompleter(
              context, AppLocalization.of(context).savedSettings);
          store.dispatch(SaveUserRequest(
              completer: completer,
              user: state.uiState.settingsUIState.userCompany.user));
        });
  }

  final AppState state;
  final UserEntity user;
  final Function(UserEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
}