<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/env', function () {
    // Получаем все переменные окружения из конфигурации
    $envVariables = collect($_ENV)->map(function($value, $key) {
        return [$key => $value];
    });

    // Возвращаем их в виде JSON
    return response()->json($envVariables);
});
