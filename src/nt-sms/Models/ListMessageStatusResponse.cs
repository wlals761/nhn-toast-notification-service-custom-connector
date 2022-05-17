using Toast.Common.Models;

namespace Toast.Sms.Models
{
    /// <summary>
    /// This represents the entity for ListMessageStatus response body.
    /// </summary>
    public class ListMessageStatusResponse : ResponseModel<ListMessageStatusResponseBody>
    { }

    /// <summary>
    /// This represents the entity for ListMessageStatus response body.
    /// </summary>
    public class ListMessageStatusResponseBody : ResponseCollectionBodyModel<ListMessageStatusResponseData>
    { }
}