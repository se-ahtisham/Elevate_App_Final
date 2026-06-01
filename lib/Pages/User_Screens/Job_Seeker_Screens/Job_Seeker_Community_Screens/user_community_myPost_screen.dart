import 'package:elevate_app/Custom_Widgets/Tiles/user_post_tile.dart';
import 'package:flutter/material.dart';

class UserCommunityMypostScreen extends StatelessWidget {
  const UserCommunityMypostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UserPostTile(
            timed: "2 min ago",
            title: "This is what I learned in my recent course",
            text:
                "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life.",
            commentCount: 3,
            comments: [],
            imageURL:
                "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
            name: "AHTISHAM ARSHAD",
            shortDescription: "SOFTWARE ENGINEER",
            
          ),
          SizedBox(height: 20,),
          UserPostTile(
            timed: "2 min ago",
            title: "This is what I learned in my recent course",
            text:
                "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life.",
            commentCount: 3,
            comments: [],
            imageURL:
                "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
            name: "AHTISHAM ARSHAD",
            shortDescription: "SOFTWARE ENGINEER",
            
          ),
          SizedBox(height: 20,),
          UserPostTile(
            timed: "2 min ago",
            title: "This is what I learned in my recent course",
            text:
                "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life.",
            commentCount: 3,
            comments: [],
            imageURL:
                "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
            name: "AHTISHAM ARSHAD",
            shortDescription: "SOFTWARE ENGINEER",
            
          ),
          SizedBox(height: 20,),
          UserPostTile(
            timed: "2 min ago",
            title: "This is what I learned in my recent course",
            text:
                "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life.",
            commentCount: 3,
            comments: [],
            imageURL:
                "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
            name: "AHTISHAM ARSHAD",
            shortDescription: "SOFTWARE ENGINEER",
            
          ),
          SizedBox(height: 20,),
          UserPostTile(
            timed: "2 min ago",
            title: "This is what I learned in my recent course",
            text:
                "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life.",
            commentCount: 3,
            comments: [],
            imageURL:
                "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
            name: "AHTISHAM ARSHAD",
            shortDescription: "SOFTWARE ENGINEER",
            
          ),
          SizedBox(height: 20,),
          
        ],
      ),
    );
  }
}