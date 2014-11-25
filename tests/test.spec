# 예시
# @method GET
# @uri /event/{number}

object {

    # 1: 호빠 이벤트, 2: 룸싸롱 이벤트
    enum display_type [1, 2];

    # 기본 이벤트 정보. 이미지 URL, 링크 URL. 버튼이미지가 노출된다면 link_value_ext1값
    $ref("/models/link.spec") link;

    string theme?;

    # 제목
    string title?;

    # 한줄문구
    string description?;

    enum content_type [205];

} $extends("/models/common_res.spec");
