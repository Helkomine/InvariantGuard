// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;
// Cung cấp khả năng bảo vệ trạng thái 
// bên ngoài hợp đồng hiện tại
// Các hạng mục bảo vệ :
// Số dư ETH địa chỉ bên ngoài (không
// cho phép chúng vi phạm bất biến nếu
// nằm trong khung thực thi của hợp đồng
// hiện tại.
// Số dư token ERC20, ERC721 trên chính nó
// và các hợp đồng nằm trong khung thực 
// thi của nó (áp dụng giả định tin tưởng 
// vào hợp đồng token, vì vậy có thể phát
// sinh các tình huống không xác định nếu
// hợp đồng token bất thường (metamorphic
// logic).
abstract contract InvariantGuardExternal {

}
