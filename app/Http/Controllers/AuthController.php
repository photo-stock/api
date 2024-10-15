<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Метод регистрации нового пользователя.
     */
    public function register(Request $request)
    {
        // Валидация данных
        try {
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:4',
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'errors' => $e->errors(),
                'message' => 'Validation failed'
            ], 400);
        }

        // Создание пользователя и хэширование пароля
        $user = User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'password' => Hash::make($validatedData['password']),
        ]);

        // Авторизация пользователя
        Auth::login($user);

        // Регенерация сессии для предотвращения фиксации сессий
        $request->session()->regenerate();

        // Возвращаем успешный ответ
        return response()->json([
            'message' => 'Registration successful',
            'user' => $user
        ], 201);
    }

    /**
     * Метод логина пользователя.
     */
    public function login(Request $request)
    {
        // Валидация данных
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        // Проверка учетных данных
        if (Auth::attempt($credentials)) {
            // Регенерация сессии
            $request->session()->regenerate();

            // Успешный ответ
            return response()->json([
                'message' => 'Successful login!'
            ], 200);
        }

        // Неверные учетные данные
        return response()->json([
            'message' => 'Wrong credentials'
        ], 400);
    }


}
