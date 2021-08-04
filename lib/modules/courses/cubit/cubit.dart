import 'package:courses/modules/courses/cubit/states.dart';
import 'package:courses/shared/components/components.dart';
import 'package:courses/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesCubit extends Cubit<CoursesStates>
{
  CoursesCubit() : super(CoursesStateInitial());
  static CoursesCubit get(context) => BlocProvider.of(context);

  List courses = [];

  int totalPages = 0;
  int currentPage = 1;

  getCourses()
  {
    emit(CoursesStateLoading());

    DioHelper.postData(
      path: 'lms/api/v1/courses',
      query:
      {
        'page': currentPage,
      },
      token: getToken(),
    ).then((value)
    {
      emit(CoursesStateSuccess());
      print(value.data.toString());

      courses = value.data['result']['data'] as List;

      currentPage ++;
      totalPages = value.data['result']['last_page'];
    }).catchError((error)
    {
      emit(CoursesStateError(error));
      print(error.toString());
    });
  }

  getMoreCourses()
  {
    emit(CoursesStateLoadingMore());

    DioHelper.postData(
      path: 'lms/api/v1/courses',
      query:
      {
        'page': currentPage,
      },
      token: getToken(),
    ).then((value)
    {
      emit(CoursesStateSuccess());
      print(value.data.toString());

      courses.addAll(value.data['result']['data'] as List);

      currentPage ++;
    }).catchError((error)
    {
      emit(CoursesStateError(error));
      print(error.toString());
    });
  }
}