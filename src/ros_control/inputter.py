from pynput import mouse, keyboard

import rclpy
from rclpy.node import Node
from std_msgs.msg import String


# Set to keep track of pressed keys
pressed_keys = set()
mouse_pos = [-1,-1]

publish = False
publishAction = False


class MinimalPublisher(Node):

    def __init__(self):
        super().__init__('cmd_vel_republisher')
        self.publisher_ = self.create_publisher(String, '/godot_cmd_vel', 1)
        timer_period = 0.1  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)

    def timer_callback(self):
        global publishAction
        global publish
        if publishAction and publish:
            publish = False
            msg = String()
            msg.data = "end"
            self.publisher_.publish(msg)
            #self.get_logger().info('Publishing: "%s"' % msg.data)
        elif publish or publishAction:
            publish = True
            msg = String()
            msg.data = f"Keys: {[str(k) for k in pressed_keys]}, Mouse: {mouse_pos}"
            self.publisher_.publish(msg)
            #self.get_logger().info('Publishing: "%s"' % msg.data)
        publishAction = False



# Define the callback functions for mouse events
def on_move(x, y):
    mouse_pos[0] = x
    mouse_pos[1] = y

def on_click(x, y, button, pressed):
    global publishAction
    if pressed:
        publishAction = True
        print(f"Mouse clicked at ({x}, {y}) with {button}")
    else:
        print(f"Mouse released at ({x}, {y}) with {button}")

def on_scroll(x, y, dx, dy):
    print(f"Mouse scrolled at ({x}, {y}) with delta ({dx}, {dy})")


# Define the callback functions for keyboard events
def on_press(key):
    pressed_keys.add(key)

def on_release(key):
    pressed_keys.discard(key)

    # Stop the listener if 'Esc' is released
    if key == keyboard.Key.esc:
        return False


def main(args=None):

    mouseListener = mouse.Listener(
    on_move=on_move,
    on_click=on_click,
    on_scroll=on_scroll)

    keyListener = keyboard.Listener(
    on_press=on_press,
    on_release=on_release)

    mouseListener.start()
    keyListener.start()


    rclpy.init(args=args)
    minimal_publisher = MinimalPublisher()
    rclpy.spin(minimal_publisher)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    minimal_publisher.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()

