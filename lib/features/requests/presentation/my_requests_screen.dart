import 'package:eg_passport_app/features/e_passport/e_passport_routes.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_shell.dart';
import 'package:eg_passport_app/features/requests/cubit/requests_cubit.dart';
import 'package:eg_passport_app/features/requests/cubit/requests_state.dart';
import 'package:eg_passport_app/features/requests/data/passport_request.dart';
import 'package:eg_passport_app/features/requests/data/requests_repository.dart';
import 'package:eg_passport_app/features/requests/presentation/widgets/request_card.dart';
import 'package:eg_passport_app/features/requests/presentation/widgets/request_filter_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  static const String routeName = EPassportRoutes.requests;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RequestsCubit(const MockRequestsRepository())..loadRequests(),
      child: const EPassportShell(
        activeDestination: EPassportDestination.requests,
        child: _MyRequestsView(),
      ),
    );
  }
}

class _MyRequestsView extends StatelessWidget {
  const _MyRequestsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        if (state is RequestsLoading) {
          return const SizedBox(
            height: 460,
            child: Center(
              child: CircularProgressIndicator(color: EPassportColors.red),
            ),
          );
        }

        if (state is RequestsLoadError) {
          return _RequestsError(message: state.message);
        }

        final loadedState = state as RequestsLoadedSuccess;
        final cubit = context.read<RequestsCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'طلباتي',
              textAlign: TextAlign.center,
              style: EPassportTextStyles.title(26),
            ),
            const SizedBox(height: 6),
            Text(
              'متابعة جميع طلبات جواز السفر الرقمي الخاصة بك',
              textAlign: TextAlign.center,
              style: EPassportTextStyles.body(
                size: 13,
                color: EPassportColors.muted,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 22),
            RequestFilterTabs(
              selectedFilter: loadedState.selectedFilter,
              onFilterSelected: cubit.filterRequests,
              countForFilter: cubit.countForFilter,
            ),
            const SizedBox(height: 18),
            if (loadedState.visibleRequests.isEmpty)
              _EmptyRequestsMessage(
                filterLabel: loadedState.selectedFilter.label,
              )
            else
              _RequestsResponsiveList(requests: loadedState.visibleRequests),
          ],
        );
      },
    );
  }
}

class _RequestsResponsiveList extends StatelessWidget {
  const _RequestsResponsiveList({required this.requests});

  final List<PassportRequest> requests;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            children: requests
                .map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: RequestCard(request: request),
                  ),
                )
                .toList(),
          );
        }

        final columns = constraints.maxWidth >= 1100 ? 2 : 1;
        if (columns == 1) {
          return Column(
            children: requests
                .map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: RequestCard(request: request),
                  ),
                )
                .toList(),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 320,
          ),
          itemBuilder: (context, index) {
            return RequestCard(request: requests[index]);
          },
        );
      },
    );
  }
}

class _EmptyRequestsMessage extends StatelessWidget {
  const _EmptyRequestsMessage({required this.filterLabel});

  final String filterLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: EPassportColors.surface,
        border: Border.all(color: EPassportColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'لا توجد طلبات ضمن تصنيف $filterLabel',
          style: EPassportTextStyles.body(
            size: 14,
            color: EPassportColors.muted,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RequestsError extends StatelessWidget {
  const _RequestsError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: EPassportColors.rejected,
              size: 38,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: EPassportTextStyles.body(
                size: 14,
                color: EPassportColors.rejected,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => context.read<RequestsCubit>().loadRequests(),
              style: ElevatedButton.styleFrom(
                backgroundColor: EPassportColors.officialBlue,
                foregroundColor: EPassportColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
