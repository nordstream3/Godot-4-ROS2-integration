// Copyright 2022 Evan Flynn
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#ifndef GODOT__GODOT_ROS__DEMOS__VIEW_PORT_HPP
#define GODOT__GODOT_ROS__DEMOS__VIEW_PORT_HPP
#include <cstring>
#include <iostream>

#include "core/object/ref_counted.h"
#include "core/string/ustring.h"
#include "core/io/image.h"

#include "rclcpp/rclcpp.hpp"
#include "rcutils/logging.h"
#include "sensor_msgs/msg/image.hpp"

class ViewPort : public RefCounted {
  GDCLASS(ViewPort, RefCounted);
public:
  static bool initialized;

  ViewPort() {
    if (!ViewPort::initialized) {
      ViewPort::initialized = true;

      bool success = true;
      try {
	rclcpp::init(0, nullptr);
      } catch (...) {
	success = false;
      }
      
      if (success) {
	// Set up logging
	rcutils_logging_initialize();

	// Optional: Set the global severity level
	rcutils_logging_set_default_logger_level(RCUTILS_LOG_SEVERITY_DEBUG);
      }
    }
    //m_pNode = memnew(rclcpp::Node("godot_image_node"));
    //m_node = std::shared_ptr<rclcpp::Node>(m_pNode);
    //auto ptr = shared_ptr<Foo>(shared_ptr<Foo>(), p);
  }

  ~ViewPort() {
      rclcpp::shutdown();
  }

  inline void create(const String &p_node, const String &p_publisher) {
    try {
        m_node = std::make_shared<rclcpp::Node>(p_node.ascii().get_data()); // "godot_image_node"
	m_pub = m_node->create_publisher<sensor_msgs::msg::Image>(p_publisher.ascii().get_data(), 10); // "image"
    } catch (...) {
    	std::cout << "error" << std::endl;
    }
  }

  inline void spin_some() {
      rclcpp::spin_some(m_node); //.get());
      //std::cout << "spin_some" << std::endl;
  }

  // publish message
  inline void pubImage(const Ref<Image> & img) {
    m_msg = std::make_unique<sensor_msgs::msg::Image>();
    // populate image data
    m_msg->height = img->get_height();
    m_msg->width = img->get_width();

    // TODO(flynneva): switch statement to handle encodings to match those supported in std ROS2 formats
    m_msg->encoding = "rgb8";
    m_msg->is_bigendian = false;
    m_msg->step = img->get_data().size() / m_msg->height;
    m_msg->data.resize(img->get_data().size());
    // TODO(flynneva): optimize this / find a better way
    std::memcpy(&m_msg->data[0], img->get_data().ptrw(), img->get_data().size());

    m_pub->publish(std::move(m_msg));
  }

protected:
  static void _bind_methods();

  // replace rclcpp::Node with your custom node
  std::shared_ptr<rclcpp::Node> m_node;
  //rclcpp::Node* m_pNode;

  // publisher
  rclcpp::Publisher<sensor_msgs::msg::Image>::SharedPtr m_pub;

  // message to publish
  std::unique_ptr<sensor_msgs::msg::Image> m_msg;
};
#endif // GODOT__GODOT_ROS__DEMOS__VIEW_PORT_HPP
