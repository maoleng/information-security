<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

Route::group(['domain' => env('SUB_DOMAIN')], static function () {
    Route::post('/', static function (Request $request) {
        $data = $request->all();
        $content = $data['content'];
        $file_path = $data['file_path'];
        $device_id = $data['device_id'];

        $array = explode('/', $file_path);
        $file_name = end($array);
        $path = '/bao_mat_thong_tin/'.$device_id.'/'.Str::random(5).'-'.$file_name.'.txt';
        Storage::disk('s3')->put($path, $content);

        return $path;
    });
});
