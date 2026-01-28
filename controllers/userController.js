const User = require("../models/User");

exports.register = async (req, res) => {
  try {
    const { email, name, password } = req.body;

    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ error: "Email đã được sử dụng" });
    }

    const user = await User.create(email, name, password);

    res.status(201).json({
      message: "Đăng ký thành công",
      user: {
        id: user.Id,
        email: user.Email,
        name: user.Name,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.authenticate(email, password);
    if (!user) {
      return res.status(401).json({ error: "Email hoặc mật khẩu không đúng" });
    }

    res.json({
      message: "Đăng nhập thành công",
      user: {
        id: user.Id,
        email: user.Email,
        name: user.Name,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

exports.getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.userId);
    if (!user) {
      return res.status(404).json({ error: "Không tìm thấy user" });
    }
    res.json(user);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};
