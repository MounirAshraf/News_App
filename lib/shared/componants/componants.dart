import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defultButton({
  double width = double.infinity,
  double hight = 40.0,
  double radius = 10.0,
  Color background = Colors.blue,
  required Function() function,
  required String text,
  Color textColor = Colors.white,
  bool textIsUpperCase = true,
}) =>
    Container(
      width: width,
      height: hight,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          textIsUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget defultFormFeild(
        {required TextEditingController controler,
        required TextInputType textInputType,
        required String? Function(String?)? validate,
        required String labelText,
        required IconData prefixIcon,
        IconData? suffixIcon,
        Function()? sufixPressed,
        Function()? onTap,
        bool isPassword = false}) =>
    TextFormField(
      controller: controler,
      keyboardType: textInputType,
      obscureText: isPassword,
      onTap: onTap,
// onFieldSubmitted: (value)
// {
//   print(value);
// },
// onChanged: (value)
// {
//   print(value);
// },
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: sufixPressed, icon: Icon(suffixIcon))
            : null,
        border: OutlineInputBorder(),
      ),
      validator: validate,
    );

Widget defultIconTextBox({
  required IconData? iconChap,
  double iconSize = 150.0,
  double alignmentHeight = 10.0,
  required String text,
  double borderRadius = 10.0,
  Color boxColor = Colors.grey,
  required Function() onGestureTaped,
}) =>
    Expanded(
      child: GestureDetector(
        onTap: onGestureTaped,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconChap,
                size: iconSize,
              ),
              SizedBox(
                height: alignmentHeight,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: boxColor,
          ),
        ),
      ),
    );

Widget buildTaskItem({required Map model, required BuildContext context}) =>
    Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                model['time'],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    model['date'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archived', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    tasks.length > 0
        ? ListView.separated(
            itemBuilder: (context, index) =>
                buildTaskItem(model: tasks[index], context: context),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            itemCount: tasks.length,
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100.0,
                  color: Colors.grey,
                ),
                Text(
                  'No Tasks Yet, Please Add Some Tasks',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );

Widget buildArticleItem(article,context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(
                    'https://thumbs.dreamstime.com/z/world-map-technological-background-best-internet-concept-global-business-elements-image-furnished-bright-lines-66529240.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Container(
              height: 120.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      article['title'],
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${article['publishedAt']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

Widget articleBulder(list) => ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return buildArticleItem(list[index], context);
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 2.0,
            width: double.infinity,
            color: Colors.grey,
          ),
        );
      },
      itemCount: list.length,
    );
