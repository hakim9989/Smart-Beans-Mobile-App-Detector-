/// Team member model
class TeamMember {
  final String index;
  final String name;
  final String role;
  final String? avatar;

  TeamMember({
    required this.index,
    required this.name,
    required this.role,
    this.avatar,
  });

  static List<TeamMember> getTeamMembers() {
    return [
      TeamMember(
        index: 'UEB3227322',
        name: 'PEPRAH Isaac',
        role: 'Team Lead & ML Engineer',
        avatar: 'lib/assets/profile/Peprah_Isaac.jpeg',
      ),
      TeamMember(
        index: 'UEB3225322',
        name: 'ASARE Ebenezer',
        role: 'Backend Developer',
        avatar: null,
      ),
      TeamMember(
        index: 'UEB3223022',
        name: 'KLEMEH Dominic',
        role: 'Frontend Developer',
        avatar: null,
      ),
      TeamMember(
        index: 'UEB3216822',
        name: 'YUSSIF Hakim',
        role: 'UI/UX Designer',
        avatar: null,
      ),
      TeamMember(
        index: 'UEB3217722',
        name: 'OSEI Isaac',
        role: 'Quality Assurance',
        avatar: null,
      ),
    ];
  }
}
