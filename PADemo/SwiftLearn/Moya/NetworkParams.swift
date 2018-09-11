//
//  NetworkParams.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation

///成功数据的回调
typealias successCallback = ((String) -> (Void))
///失败的回调
typealias failedCallback = ((String) -> (Void))
///网络错误的回调
typealias errorCallback = (() -> (Void))

func decodeBase64ToData(_ string: String) -> CFData? {
    if let data = Data(base64Encoded: string, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
        let tmp = data as CFData
        return tmp
    }
    return nil
}

//ca证书16进制数据的base64编码
struct PAPinganwjCer {
    static let kpinganwjKey = "MIIF3zCCBMegAwIBAgIQAtpbI8tWMwkAIVL+vRpewzANBgkqhkiG9w0BAQsFADBE\nMQswCQYDVQQGEwJDTjEaMBgGA1UECgwRV29TaWduIENBIExpbWl0ZWQxGTAXBgNV\nBAMMEFdvU2lnbiBPViBTU0wgQ0EwHhcNMTcwNDExMTA0NzIzWhcNMTkwNDExMTA0\nNzIzWjCBiTELMAkGA1UEBhMCQ04xOTA3BgNVBAoMMOW5s+WuieS4h+WutuWMu+eW\nl+aKlei1hOeuoeeQhuaciemZkOi0o+S7u+WFrOWPuDESMBAGA1UEBwwJ5rex5Zyz\n5biCMRIwEAYDVQQIDAnlub/kuJznnIExFzAVBgNVBAMMDioucGluZ2Fud2ouY29t\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsii14wVZQThnfiGbtgQE\nkO3aiC+EmSCjOEwMkQZc+g7Bi8DSBf8L/hJWnymViUw2PRzKUcBuWy5djkpbHAB0\n0siE/n5+1Zg7Eu8gkMhf08aPtTJzWtxlsZhDxqvDjEVubtsvuSp6K6toidpL6+BQ\n1uVMt3uxyRsrLFiuuExqr6azQkoO6gW7ITAOlIGouJlZrYTO+biZjD+3GWOd4Usx\nMse3qfsMjFq6S3z9fXVx7hlP+cZXjcYfQ/ZXKa2CFhKtyCfrV/W5f+b7hL1pk2fS\nLktop/v/ycpQAAXLmn4oTArRv1d8pxzBIaUqzyOHjg3sZAludDR8t8D5U9+WKULf\n7QIDAQABo4IChTCCAoEwDAYDVR0TAQH/BAIwADA8BgNVHR8ENTAzMDGgL6Athito\ndHRwOi8vd29zaWduLmNybC5jZXJ0dW0ucGwvd29zaWduLW92Y2EuY3JsMHcGCCsG\nAQUFBwEBBGswaTAuBggrBgEFBQcwAYYiaHR0cDovL3dvc2lnbi1vdmNhLm9jc3At\nY2VydHVtLmNvbTA3BggrBgEFBQcwAoYraHR0cDovL3JlcG9zaXRvcnkuY2VydHVt\nLnBsL3dvc2lnbi1vdmNhLmNlcjAfBgNVHSMEGDAWgBShE1TcVnMsJ4LKyITv7r8A\n/V+rVjAdBgNVHQ4EFgQUroiiFHIJ1vqY5FoyIaMz0MVPG1MwDgYDVR0PAQH/BAQD\nAgWgMIIBIAYDVR0gBIIBFzCCARMwCAYGZ4EMAQICMIIBBQYMKoRoAYb2dwIFAQwC\nMIH0MIHxBggrBgEFBQcCAjCB5DAfFhhBc3NlY28gRGF0YSBTeXN0ZW1zIFMuQS4w\nAwIBARqBwFVzYWdlIG9mIHRoaXMgY2VydGlmaWNhdGUgaXMgc3RyaWN0bHkgc3Vi\namVjdGVkIHRvIHRoZSBDRVJUVU0gQ2VydGlmaWNhdGlvbiBQcmFjdGljZSBTdGF0\nZW1lbnQgKENQUykgaW5jb3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZSBoZXJlaW4gYW5k\nIGluIHRoZSByZXBvc2l0b3J5IGF0IGh0dHBzOi8vd3d3LmNlcnR1bS5wbC9yZXBv\nc2l0b3J5LjAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwJwYDVR0RBCAw\nHoIOKi5waW5nYW53ai5jb22CDHBpbmdhbndqLmNvbTANBgkqhkiG9w0BAQsFAAOC\nAQEAZ4lxXUw0GRS6RZS7R20t2GXDa4G8w4I4MshwUNxUmdWYep/Njini41O4z3Gt\ns8+T/1ymj1xTJdnQatYR7ghbogIGD2OjKwVODJKZ7N/hFga5kzm4DpWaCdKLnAiv\nq8e1eHTewlmth4/oiFbgSM/+/5RSb5getxORpHWwbN7wA3VBoXovP5Aj233YIrib\nw9VZkn4PcWUxs57bd/mi0FwPSyfgZl/3Wzz7ddkc+Jl3nWZdos63hyxK4Z6Mtqzf\n/4PvuXcpqi//HjAnitdTSpOxJYeBDaZm4CHiLnCEyhm58DKfme9rxDdrXugZFPcN\nf2d3Ck49b27DMBziuG+02HKwog=="
}

