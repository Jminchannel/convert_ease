# Convert Ease 代码规范

## 📋 目录
- [项目结构](#项目结构)
- [命名规范](#命名规范)
- [代码风格](#代码风格)
- [架构原则](#架构原则)
- [最佳实践](#最佳实践)

## 🏗️ 项目结构

```
lib/
├── core/                   # 核心模块
│   ├── constants/         # 常量定义
│   ├── theme/            # 主题配置
│   ├── utils/            # 工具类
│   └── widgets/          # 通用组件
├── ui/                    # 用户界面
│   ├── pages/            # 页面
│   └── widgets/          # 页面级组件
└── main.dart             # 应用入口
```

## 📝 命名规范

### 文件命名
- 使用 `snake_case`
- 文件名应该描述其功能
- 示例：`splash_screen.dart`, `app_constants.dart`

### 类命名
- 使用 `PascalCase`
- 组件以用途结尾：`Widget`, `Screen`, `Page`
- 示例：`SplashScreen`, `AppLoadingWidget`

### 变量和方法命名
- 使用 `camelCase`
- 私有成员以下划线开头
- 示例：`userName`, `_initializeAnimations()`

### 常量命名
- 使用 `camelCase`
- 静态常量使用 `lowerCamelCase`
- 示例：`static const String appName = 'Convert Ease';`

## 🎨 代码风格

### 导入顺序
1. Dart 核心库
2. Flutter 库
3. 第三方包
4. 项目内部导入

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import '../core/constants/app_constants.dart';
```

### 代码组织
- 每个类的成员按以下顺序组织：
  1. 静态常量
  2. 实例变量
  3. 构造函数
  4. 重写方法（如 `build`）
  5. 公共方法
  6. 私有方法

### 文档注释
- 所有公共类和方法必须有文档注释
- 使用三斜杠 `///` 格式
- 简洁明了地描述功能

```dart
/// 启动画面组件
///
/// 显示应用logo、动画效果和版本信息，
/// 在动画完成后自动跳转到主页面
class SplashScreen extends StatefulWidget {
  // ...
}
```

## 🏛️ 架构原则

### 关注点分离
- UI 组件只负责显示
- 业务逻辑封装在服务类中
- 常量和配置统一管理

### 组件化
- 复杂的 UI 拆分为小组件
- 通用组件放在 `core/widgets/`
- 页面级组件放在对应页面文件夹

### 状态管理
- 简单状态使用 `setState`
- 复杂状态考虑使用状态管理方案

## 🚀 最佳实践

### 性能优化
- 使用 `const` 构造函数
- 避免在 `build` 方法中创建对象
- 合理使用 `AnimationController`

### 错误处理
- 所有异步操作都要有错误处理
- 使用 `AppLogger` 记录错误信息
- 为用户提供友好的错误提示

### 代码质量
- 运行 `flutter analyze` 确保无警告
- 使用 `dart format` 格式化代码
- 编写有意义的注释

### 资源管理
- 及时释放动画控制器等资源
- 检查 `mounted` 状态再调用 `setState`

### 测试
- 为关键功能编写单元测试
- 使用模拟数据进行测试

## 🔧 开发工具配置

### IDE 设置
- 启用自动格式化
- 配置 linter 规则
- 使用代码片段提高效率

### Git 提交规范
- 提交信息使用中文
- 格式：`类型: 简短描述`
- 示例：`功能: 添加启动画面动画效果`

## 📚 参考资料
- [Flutter 官方风格指南](https://dart.dev/guides/language/effective-dart/style)
- [Material Design 规范](https://material.io/design)
- [Flutter 最佳实践](https://docs.flutter.dev/development/best-practices)
