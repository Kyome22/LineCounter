/*
 CountError.swift

 Created by ky0me22 on 2022/03/11.
*/

enum CountError: Error {
    case skipped(String)
    case failedToRead(String)
}
