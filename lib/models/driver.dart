class Driver {
  final String id;
  final String name;
  final String type;
  final String status;
  final String ambulanceNo;
  final String email;
  final String imageUrl;
  final bool approvalStat;
  Driver(
      {this.ambulanceNo,
      this.id,
      this.approvalStat,
      this.email,
      this.imageUrl,
      this.name,
      this.status,
      this.type});
}
